package servlet.users;

import dao.*;
import model.Paciente.Paciente;
import model.ServicoMedicoAgendamento;
import model.Utilizador.Cliente;
import model.Utilizador.Utilizador;
import model.Utilizador.Veterinario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;

@WebServlet("/GerenteServlet")
public class GerenteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();
        Utilizador user = (Utilizador) session.getAttribute("utilizador");

        if (user == null || !user.isGerente()) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        if (action == null || "dashboard".equals(action)) {
            req.getRequestDispatcher("/gerente/menuGerente.jsp").forward(req, resp);
        }
        // 4.1 - GESTÃO VETERINÁRIOS
        else if ("listarVets".equals(action)) {
            List<Veterinario> vets = new VeterinarioDAO().listarTodos();
            req.setAttribute("vets", vets);
            req.getRequestDispatcher("/gerente/criarAtualizarVet.jsp").forward(req, resp);

        } else if ("editarVet".equals(action)) {
            String licenca = req.getParameter("licenca");
            Veterinario v = new VeterinarioDAO().buscarPorLicenca(licenca);
            req.setAttribute("vetEditar", v);
            List<Veterinario> vets = new VeterinarioDAO().listarTodos();
            req.setAttribute("vets", vets);
            req.getRequestDispatcher("/gerente/criarAtualizarVet.jsp").forward(req, resp);

        } else if ("gerirTutores".equals(action)) {
            List<Cliente> clientes = new ClienteDAO().listarTodos();
            req.setAttribute("clientes", clientes);
            req.getRequestDispatcher("/gerente/gerirTutorAnimais.jsp").forward(req, resp);

        }   // 4.2 - GESTÃO DE HORÁRIOS
        else if ("horarios".equals(action)) {
            List<Veterinario> vets = new VeterinarioDAO().listarTodos();
            req.setAttribute("vets", vets);
            req.getRequestDispatcher("/gerente/atualizarHorarios.jsp").forward(req, resp);

        } else if ("editarTutor".equals(action)) {
            String nifStr = req.getParameter("nif");

            try {
                Cliente c = new ClienteDAO().findByNif(Integer.parseInt(nifStr));
                req.setAttribute("clienteEditar", c);

                List<Cliente> clientes = new ClienteDAO().listarTodos();
                req.setAttribute("clientes", clientes);
                req.getRequestDispatcher("/gerente/gerirTutorAnimais.jsp").forward(req, resp);
            } catch (NumberFormatException | SQLException e) {
                resp.sendRedirect("GerenteServlet?action=gerirTutores&msg=erroNIF");
            }
        }

        // 4.3 e 4.4 - IMPORTAR / EXPORTAR
        else if ("exportImport".equals(action)) {
            List<Paciente> animais = new PacienteDAO().listarTodos();
            req.setAttribute("animais", animais);
            req.getRequestDispatcher("/gerente/IM_EX_XML_JSON.jsp").forward(req, resp);

        } else if ("downloadJSON".equals(action)) {
            exportarJSON(req, resp);

        } else if ("downloadXML".equals(action)) {
            exportarXML(req, resp);
        }

        else if ("statsVida".equals(action)) {
            List<Map<String, Object>> dados = new GerenteDAO().getAnimaisExcederamExpectativa();
            req.setAttribute("dados", dados);
            req.getRequestDispatcher("/gerente/animaisExpectVida.jsp").forward(req, resp);
        }

        // --- ESTATÍSTICA: EXCESSO DE PESO ---
        else if ("statsPeso".equals(action)) {
            List<Map<String, Object>> dados = new GerenteDAO().getTutoresAnimaisExcessoPeso();
            req.setAttribute("dados", dados);
            req.getRequestDispatcher("/gerente/tutoresPeso.jsp").forward(req, resp);
        }

        // --- ESTATÍSTICA: CANCELAMENTOS ---
        else if ("statsCancel".equals(action)) {
            List<Map<String, Object>> dados = new GerenteDAO().getTopCancelamentosTrimestre();
            req.setAttribute("dados", dados);
            req.getRequestDispatcher("/gerente/tutoresCancelamento.jsp").forward(req, resp);
        }

        // --- ESTATÍSTICA: PREVISÃO SEMANAL ---
        else if ("statsSemana".equals(action)) {
            List<Map<String, Object>> dados = new GerenteDAO().getPrevisaoSemana();
            req.setAttribute("dados", dados);
            req.getRequestDispatcher("/gerente/statsServico.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        GerenteDAO gDao = new GerenteDAO();
        VeterinarioDAO vDao = new VeterinarioDAO();

        if ("salvarVet".equals(action)) {
            try {
                Veterinario v = new Veterinario();
                v.setnLicenca(req.getParameter("nLicenca"));
                v.setNome(req.getParameter("nome"));
                v.setIdade(Integer.parseInt(req.getParameter("idade")));
                v.setEspecialidade(req.getParameter("especialidade"));

                String idStr = req.getParameter("idUtilizador");
                if (idStr == null || idStr.equals("0") || idStr.isEmpty()) {
                    vDao.criarVeterinarioCompleto(v, req.getParameter("username"), req.getParameter("password"));
                } else {
                    v.setiDUtilizador(Integer.parseInt(idStr));
                    vDao.atualizarVeterinario(v);
                }
                resp.sendRedirect("GerenteServlet?action=listarVets&msg=sucesso");
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect("GerenteServlet?action=listarVets&msg=erro");
            }
        } else if ("salvarTutor".equals(action)) {
            try {
                Cliente c = new Cliente();
                c.setNome(req.getParameter("nome"));
                c.setNIF(req.getParameter("nif")); // SetNif deve aceitar String
                c.setEmail(req.getParameter("email"));
                c.setTelefone(req.getParameter("telefone"));
                c.setRua(req.getParameter("rua"));
                c.setFreguesia(req.getParameter("freguesia"));
                c.setConcelho(req.getParameter("concelho"));
                c.setDistrito(req.getParameter("distrito"));
                c.setPais(req.getParameter("pais"));

                String idStr = req.getParameter("idUtilizador");
                ClienteDAO cDao = new ClienteDAO();

                if (idStr == null || "0".equals(idStr) || idStr.isEmpty()) {
                    // Criar Novo (Requer lógica de criar utilizador também)
                    // Podes usar um método similar ao do Veterinário no ClienteDAO ou AuthDAO
                    // Exemplo simplificado (idealmente cria User + Cliente em transação):
                    cDao.criarClienteCompleto(c, req.getParameter("username"), req.getParameter("password"));
                    resp.sendRedirect("GerenteServlet?action=gerirTutores&msg=criado");
                } else {
                    // Atualizar
                    c.setiDUtilizador(Integer.parseInt(idStr));
                    cDao.update(c);
                    resp.sendRedirect("GerenteServlet?action=gerirTutores&msg=atualizado");
                }
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect("GerenteServlet?action=gerirTutores&msg=erroSalvar");
            }
        } else if ("atribuirHorario".equals(action)) {
            try {
                boolean ok = gDao.atribuirHorario(req.getParameter("nLicenca"), req.getParameter("localidade"), req.getParameter("diaUtil"));
                resp.sendRedirect("GerenteServlet?action=horarios&msg=" + (ok ? "sucesso" : "erroConflito"));
            } catch (Exception e) {
                resp.sendRedirect("GerenteServlet?action=horarios&msg=erroBD");
            }
        } else if ("importarJSON".equals(action)) {
            importarJSON(req, resp);
        } else if ("importarXML".equals(action)) {
            importarXML(req, resp);
        }
    }

    // ================= MÉTODOS DE EXPORTAÇÃO (Com Todos os Campos) =================

    private void exportarJSON(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("idPaciente"));
            Paciente p = new PacienteDAO().findById(id);
            List<ServicoMedicoAgendamento> hist = new AgendamentoDAO().listarPorAnimal(id);

            StringBuilder json = new StringBuilder();
            json.append("{\n");
            json.append("  \"idpaciente\": \"").append(p.getidPaciente()).append("\",\n");
            json.append("  \"nome\": \"").append(p.getNome()).append("\",\n");
            json.append("  \"idade\": \"").append(p.getIdade()).append("\",\n");
            json.append("  \"raca\": \"").append(p.getRaca()).append("\",\n");
            json.append("  \"sexo\": \"").append(p.getSexo()).append("\",\n");
            json.append("  \"peso\": \"").append(p.getPesoAtual()).append("\",\n");
            json.append("  \"dataNascimento\": \"").append(p.getDataNascimento()).append("\",\n");
            json.append("  \"dataObito\": \"").append(p.getDataObito() != null ? p.getDataObito() : "").append("\",\n");
            json.append("  \"donoNIF\": \"").append(p.getNifDono()).append("\",\n");
            json.append("  \"transponder\": \"").append(p.getTransponder() != null ? p.getTransponder() : "").append("\",\n");
            json.append("  \"servicos\": [\n");

            for (int i = 0; i < hist.size(); i++) {
                ServicoMedicoAgendamento s = hist.get(i);
                json.append("    { \"data\": \"").append(s.getDataHoraAgendada()).append("\", \"tipo\": \"").append(s.getTipoServico()).append("\" }");
                if (i < hist.size() - 1) json.append(",\n");
            }
            json.append("\n  ]\n}");

            resp.setContentType("application/json");
            resp.setHeader("Content-Disposition", "attachment; filename=" + p.getNome() + ".json");
            resp.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void exportarXML(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("idPaciente"));
            Paciente p = new PacienteDAO().findById(id);
            List<ServicoMedicoAgendamento> hist = new AgendamentoDAO().listarPorAnimal(id);

            StringBuilder xml = new StringBuilder();
            xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
            xml.append("<FichaAnimal>\n");
            xml.append("  <idpaciente>").append(p.getidPaciente()).append("</idpaciente>\n");
            xml.append("  <nome>").append(p.getNome()).append("</nome>\n");
            xml.append("  <idade>").append(p.getIdade()).append("</idade>\n");
            xml.append("  <raca>").append(p.getRaca()).append("</raca>\n");
            xml.append("  <sexo>").append(p.getSexo()).append("</sexo>\n");
            xml.append("  <peso>").append(p.getPesoAtual()).append("</peso>\n");
            xml.append("  <dataNascimento>").append(p.getDataNascimento()).append("</dataNascimento>\n");
            xml.append("  <dataObito>").append(p.getDataObito() != null ? p.getDataObito() : "").append("</dataObito>\n");
            xml.append("  <donoNIF>").append(p.getNifDono()).append("</donoNIF>\n");
            xml.append("  <transponder>").append(p.getTransponder() != null ? p.getTransponder() : "").append("</transponder>\n");
            xml.append("  <servicos>\n");
            for (ServicoMedicoAgendamento s : hist) {
                xml.append("    <servico>\n");
                xml.append("      <data>").append(s.getDataHoraAgendada()).append("</data>\n");
                xml.append("      <tipo>").append(s.getTipoServico()).append("</tipo>\n");
                xml.append("    </servico>\n");
            }
            xml.append("  </servicos>\n");
            xml.append("</FichaAnimal>");

            resp.setContentType("application/xml");
            resp.setHeader("Content-Disposition", "attachment; filename=" + p.getNome() + ".xml");
            resp.getWriter().write(xml.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= MÉTODOS DE IMPORTAÇÃO=================

    private void importarJSON(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String content = req.getParameter("jsonContent");
        try {
            String nome = extrairValor(content, "\"nome\": \"", "\"");
            String raca = extrairValor(content, "\"raca\": \"", "\"");
            String nif = extrairValor(content, "\"donoNIF\": \"", "\"");
            String transponder = extrairValor(content, "\"transponder\": \"", "\"");

            // Novos campos obrigatórios
            String dataNascStr = extrairValor(content, "\"dataNascimento\": \"", "\"");
            String pesoStr = extrairValor(content, "\"peso\": \"", "\"");
            String sexoStr = extrairValor(content, "\"sexo\": \"", "\"");
            String dataObitoStr = extrairValor(content, "\"dataObito\": \"", "\"");

            salvarPacienteImportado(nome, raca, nif, transponder, dataNascStr, pesoStr, sexoStr, dataObitoStr);
            resp.sendRedirect("GerenteServlet?action=exportImport&msg=importadoSucesso");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("GerenteServlet?action=exportImport&msg=erroFormato");
        }
    }

    private void importarXML(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String content = req.getParameter("xmlContent");
        try {
            String nome = extrairValor(content, "<nome>", "</nome>");
            String raca = extrairValor(content, "<raca>", "</raca>");
            String nif = extrairValor(content, "<donoNIF>", "</donoNIF>");
            String transponder = extrairValor(content, "<transponder>", "</transponder>");

            // Novos campos
            String dataNascStr = extrairValor(content, "<dataNascimento>", "</dataNascimento>");
            String pesoStr = extrairValor(content, "<peso>", "</peso>");
            String sexoStr = extrairValor(content, "<sexo>", "</sexo>");
            String dataObitoStr = extrairValor(content, "<dataObito>", "</dataObito>");

            salvarPacienteImportado(nome, raca, nif, transponder, dataNascStr, pesoStr, sexoStr, dataObitoStr);
            resp.sendRedirect("GerenteServlet?action=exportImport&msg=importadoSucesso");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("GerenteServlet?action=exportImport&msg=erroFormato");
        }
    }

    private void salvarPacienteImportado(String nome, String raca, String nif, String transponder, String dataNascStr, String pesoStr, String sexoStr, String dataObitoStr) throws Exception {

        // 1. Validação de dados obrigatórios (Sem defaults inventados)
        if (nome == null || nif == null || raca == null || dataNascStr == null || pesoStr == null || sexoStr == null) {
            throw new Exception("Dados obrigatórios em falta no ficheiro.");
        }

        Paciente p = new Paciente();
        p.setNome(nome);
        p.setRaca(raca);
        p.setNifDono(nif);
        p.setTransponder((transponder != null && !transponder.isEmpty()) ? transponder : null);

        // 2. Conversão de dados (Lança erro se formato inválido)
        try {
            p.setDataNascimento(LocalDate.parse(dataNascStr)); // Formato YYYY-MM-DD
            p.setPesoAtual(Double.parseDouble(pesoStr));
            p.setSexo(sexoStr.charAt(0));

            if (dataObitoStr != null && !dataObitoStr.isEmpty()) {
                p.setDataObito(LocalDate.parse(dataObitoStr));
            } else {
                p.setDataObito(null);
            }
        } catch (DateTimeParseException | NumberFormatException e) {
            throw new Exception("Erro ao converter datas ou números do ficheiro.");
        }

        // 3. Validação Lógica Básica
        if (p.getPesoAtual() <= 0) throw new Exception("O peso deve ser maior que 0.");

        new PacienteDAO().insert(p);
    }

    private String extrairValor(String source, String startTag, String endTag) {
        int start = source.indexOf(startTag);
        if (start == -1) return null;
        start += startTag.length();
        int end = source.indexOf(endTag, start);
        if (end == -1) return null;
        return source.substring(start, end).trim();
    }
}