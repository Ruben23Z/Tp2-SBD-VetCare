package servlet.users;

import dao.AgendamentoDAO;
import dao.GerenteDAO;
import dao.PacienteDAO;
import dao.VeterinarioDAO;
import model.Paciente.Paciente;
import model.ServicoMedicoAgendamento;
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
import java.util.List;
import java.util.Map;

@WebServlet("/GerenteServlet")
public class GerenteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();
        Utilizador user = (Utilizador) session.getAttribute("utilizador");

        // Proteção: Apenas Gerentes
        if (user == null || !user.isGerente()) {
            resp.sendRedirect("login.jsp");
            return;
        }

        GerenteDAO dao = new GerenteDAO();

        // --- DASHBOARD ---
        if (action == null || "dashboard".equals(action)) {
            req.getRequestDispatcher("gerente/menuGerente.jsp").forward(req, resp);
        }

        // --- 4.1 LISTAR VETERINÁRIOS (Para Editar/Criar) ---
        else if ("listarVets".equals(action)) {
            VeterinarioDAO vDao = new VeterinarioDAO();
            List<Veterinario> vets = vDao.listarTodos();
            req.setAttribute("vets", vets);
            req.getRequestDispatcher("gerente/criarAtualizarVet.jsp").forward(req, resp);
        } else if ("gerirTutores".equals(action)) {
            // Redireciona para o servlet de rececionista ou carrega a view de clientes
            resp.sendRedirect(req.getContextPath() + "/RececionistaServlet?acao=listarClientes");
        }

        // --- 4.2 GERIR HORÁRIOS ---
        else if ("horarios".equals(action)) {
            VeterinarioDAO vDao = new VeterinarioDAO();
            List<Veterinario> vets = vDao.listarTodos();
            req.setAttribute("vets", vets);
            req.getRequestDispatcher("gerente/atualizarHorarios.jsp").forward(req, resp);
        }

        // --- 4.3 / 4.4 MENU IMPORTAR/EXPORTAR ---
        else if ("exportImport".equals(action)) {
            List<Paciente> animais = new PacienteDAO().listarTodos();
            req.setAttribute("animais", animais);
            req.getRequestDispatcher("gerente/IM_EX_XML_JSON.jsp").forward(req, resp);
        }

        // --- 4.3 DOWNLOAD JSON (Exportação) ---
        else if ("downloadJSON".equals(action)) {
            try {
                int idPaciente = Integer.parseInt(req.getParameter("idPaciente"));
                Paciente p = new PacienteDAO().findById(idPaciente);

                // JSON Simples (apenas dados essenciais para recriar)
                StringBuilder json = new StringBuilder();
                json.append("{\n");
                json.append("  \"nome\": \"").append(p.getNome()).append("\",\n");
                json.append("  \"raca\": \"").append(p.getRaca()).append("\",\n");
                json.append("  \"donoNIF\": \"").append(p.getNifDono()).append("\",\n");
                json.append("  \"transponder\": \"").append(p.getTransponder() != null ? p.getTransponder() : "").append("\"\n");
                json.append("}");

                resp.setContentType("application/json");
                resp.setHeader("Content-Disposition", "attachment; filename=ficha_" + p.getNome() + ".json");
                resp.getWriter().write(json.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // --- 4.5 ESTATÍSTICA: EXPECTATIVA DE VIDA ---
        else if ("statsVida".equals(action)) {
            List<Map<String, Object>> dados = dao.getAnimaisExcederamExpectativa();
            req.setAttribute("dados", dados);
            req.getRequestDispatcher("gerente/animaisExpectVida.jsp").forward(req, resp);
        }

        // --- 4.6 ESTATÍSTICA: EXCESSO DE PESO ---
        else if ("statsPeso".equals(action)) {
            List<Map<String, Object>> dados = dao.getTutoresAnimaisExcessoPeso();

            req.setAttribute("dados", dados);
            req.getRequestDispatcher("gerente/tutoresPeso.jsp").forward(req, resp);
        }

        // --- 4.7 ESTATÍSTICA: CANCELAMENTOS ---
        else if ("statsCancel".equals(action)) {
            List<Map<String, Object>> dados = dao.getTopCancelamentosTrimestre();
            req.setAttribute("dados", dados);
            req.getRequestDispatcher("gerente/tutoresCancelamento.jsp").forward(req, resp);
        }

        // --- 4.8 ESTATÍSTICA: PREVISÃO SEMANAL ---
        else if ("statsSemana".equals(action)) {
            List<Map<String, Object>> dados = dao.getPrevisaoSemana();
            req.setAttribute("dados", dados);
            req.getRequestDispatcher("gerente/statsServico.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        GerenteDAO dao = new GerenteDAO();

        // --- 4.2 ATRIBUIR HORÁRIO ---
        if ("atribuirHorario".equals(action)) {
            try {
                String nLicenca = req.getParameter("nLicenca");
                String localidade = req.getParameter("localidade");
                String dia = req.getParameter("diaUtil");

                boolean sucesso = dao.atribuirHorario(nLicenca, localidade, dia);

                if (sucesso) {
                    resp.sendRedirect("GerenteServlet?action=horarios&msg=sucesso");
                } else {
                    resp.sendRedirect("GerenteServlet?action=horarios&msg=erroConflito");
                }
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect("GerenteServlet?action=horarios&msg=erroBD");
            }
        }

        // --- 4.4 IMPORTAR JSON (Simulação) ---
        else if ("importarJSON".equals(action)) {
            String jsonContent = req.getParameter("jsonContent");
            if (jsonContent != null && !jsonContent.isEmpty()) {
                try {
                    // Extração Robusta
                    String nome = extrairValorJSON(jsonContent, "nome");
                    String raca = extrairValorJSON(jsonContent, "raca");
                    String nifDono = extrairValorJSON(jsonContent, "donoNIF");
                    String transponder = extrairValorJSON(jsonContent, "transponder");

                    if (nome != null && raca != null && nifDono != null) {
                        Paciente p = new Paciente();
                        p.setNome(nome);
                        p.setRaca(raca);
                        p.setNifDono(nifDono);
                        if (transponder != null && !transponder.isEmpty()) p.setTransponder(transponder);

                        // Valores default obrigatórios
                        p.setDataNascimento(java.time.LocalDate.now());
                        p.setSexo('M');
                        p.setPesoAtual(1.0); // Evita erro CHECK > 0

                        new PacienteDAO().insert(p);
                        resp.sendRedirect("GerenteServlet?action=exportImport&msg=importadoSucesso");
                    } else {
                        resp.sendRedirect("GerenteServlet?action=exportImport&msg=erroDadosIncompletos");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    resp.sendRedirect("GerenteServlet?action=exportImport&msg=erroFormato");
                }
            }
        }
    }


    // Método auxiliar rudimentar para ler JSON sem bibliotecas
    private String extrairValorJSON(String json, String chave) {
        String search = "\"" + chave + "\":";
        int start = json.indexOf(search);
        if (start == -1) return null;

        start += search.length();

        // Encontrar onde começa o valor (ignora espaços e aspas)
        while (start < json.length() && (json.charAt(start) == ' ' || json.charAt(start) == '"')) {
            start++;
        }

        int end = start;
        // Lê até encontrar a próxima aspa ou vírgula
        while (end < json.length() && json.charAt(end) != '"' && json.charAt(end) != ',') {
            end++;
        }

        return json.substring(start, end);
    }
}