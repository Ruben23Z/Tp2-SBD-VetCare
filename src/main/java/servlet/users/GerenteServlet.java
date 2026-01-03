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
                List<ServicoMedicoAgendamento> hist = new AgendamentoDAO().listarPorAnimal(idPaciente);

                // Construção manual do JSON
                StringBuilder json = new StringBuilder();
                json.append("{");
                json.append("\"id\": ").append(p.getidPaciente()).append(",");
                json.append("\"nome\": \"").append(p.getNome()).append("\",");
                json.append("\"raca\": \"").append(p.getRaca()).append("\",");
                json.append("\"donoNIF\": \"").append(p.getNifDono()).append("\",");
                json.append("\"historico\": [");

                for (int i = 0; i < hist.size(); i++) {
                    ServicoMedicoAgendamento s = hist.get(i);
                    json.append("{");
                    json.append("\"data\": \"").append(s.getDataHoraAgendada()).append("\",");
                    json.append("\"servico\": \"").append(s.getTipoServico()).append("\",");
                    json.append("\"descricao\": \"").append(s.getDescricao()).append("\"");
                    json.append("}");
                    if (i < hist.size() - 1) json.append(",");
                }
                json.append("]}");

                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.setHeader("Content-Disposition", "attachment; filename=ficha_" + p.getNome() + ".json");

                PrintWriter out = resp.getWriter();
                out.print(json.toString());
                out.flush();
            } catch (Exception e) {
                e.printStackTrace();
            }
            return;
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
                // Aqui entraria a lógica de parsing para salvar na BD
                System.out.println("JSON Importado: " + jsonContent);
                resp.sendRedirect("GerenteServlet?action=exportImport&msg=importadoSucesso");
            } else {
                resp.sendRedirect("GerenteServlet?action=exportImport&msg=erroVazio");
            }
        }
    }
}