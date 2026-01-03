package servlet.users;

import dao.AgendamentoDAO;
import dao.ClienteDAO;
import dao.PacienteDAO;
import model.Paciente.Paciente;
import model.ServicoMedicoAgendamento;
import model.Utilizador.Utilizador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/TutorServlet")
public class TutorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();
        Utilizador user = (Utilizador) session.getAttribute("utilizador");

        // Proteção de Login
        if (user == null || !user.isCliente()) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // 1. DASHBOARD: Listar animais do cliente
        if ("dashboard".equals(action)) {
            ClienteDAO cDao = new ClienteDAO();
            PacienteDAO pDao = new PacienteDAO();
            String nif = cDao.getNifByIdUtilizador(user.getiDUtilizador());

            if (nif != null) {
                List<Paciente> meusAnimais = pDao.listarPorNif(nif);
                req.setAttribute("meusAnimais", meusAnimais);
            }
            // APONTA PARA A PASTA 'cliente'
            req.getRequestDispatcher("cliente/consultar.jsp").forward(req, resp);
        }

        // 2. VER FICHA (Usa o novo nome fichaAnimalCliente.jsp)
        else if ("verFicha".equals(action)) {
            try {
                int idPaciente = Integer.parseInt(req.getParameter("idPaciente"));
                Paciente p = new PacienteDAO().findById(idPaciente);
                List<ServicoMedicoAgendamento> historico = new AgendamentoDAO().listarPorAnimal(idPaciente);

                req.setAttribute("animal", p);
                req.setAttribute("historico", historico);

                // APONTA PARA O FICHEIRO ESPECÍFICO DO CLIENTE
                req.getRequestDispatcher("cliente/fichaAnimalCliente.jsp").forward(req, resp);

            } catch (Exception e) {
                resp.sendRedirect("TutorServlet?action=dashboard");
            }
        }

        // 3. AGENDAR
        else if ("agendar".equals(action)) {
            int idPaciente = Integer.parseInt(req.getParameter("idPaciente"));
            Paciente p = new PacienteDAO().findById(idPaciente);
            req.setAttribute("animal", p);
            // APONTA PARA O FICHEIRO NA PASTA 'cliente'
            req.getRequestDispatcher("cliente/agendar.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        AgendamentoDAO dao = new AgendamentoDAO();

        try {
            int idPaciente = Integer.parseInt(req.getParameter("idPaciente"));

            if ("criar".equals(action)) {
                ServicoMedicoAgendamento s = new ServicoMedicoAgendamento(0, null, null);
                s.setDescricao(req.getParameter("descricao"));
                s.setLocalidade(req.getParameter("localidade"));
                s.setIdPaciente(idPaciente);
                s.setIdUtilizador(null);

                String dataStr = req.getParameter("dataHora");
                if (dataStr != null) s.setDataHoraAgendada(LocalDateTime.parse(dataStr));

                String tipo = req.getParameter("tipoServico");
                dao.criar(s, tipo);

                resp.sendRedirect("TutorServlet?action=verFicha&idPaciente=" + idPaciente + "&msg=agendado");
            }
            else if ("cancelar".equals(action)) {
                int idServico = Integer.parseInt(req.getParameter("idServico"));
                dao.cancelar(idServico);
                resp.sendRedirect("TutorServlet?action=verFicha&idPaciente=" + idPaciente + "&msg=cancelado");
            }
            else if ("reagendar".equals(action)) {
                int idServico = Integer.parseInt(req.getParameter("idServico"));
                String novaData = req.getParameter("novaDataHora");
                if (novaData != null && !novaData.isEmpty()) {
                    dao.reagendar(idServico, LocalDateTime.parse(novaData));
                    resp.sendRedirect("TutorServlet?action=verFicha&idPaciente=" + idPaciente + "&msg=reagendado");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("TutorServlet?action=dashboard&msg=erro");
        }
    }
}