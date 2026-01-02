package servlet;

import dao.AgendamentoDAO;
import dao.PacienteDAO;
import dao.VeterinarioDAO;
import model.Paciente;
import model.ServicoMedicoAgendamento;
import model.Utilizador.Veterinario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AgendamentoServlet")
public class AgendamentoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        // Se a ação for "novo", abre a página de agendamento geral (sem animal pré-selecionado)
        if ("novo".equals(action)) {
            // Carregar lista de animais para o dropdown
            List<Paciente> listaAnimais = new PacienteDAO().listarTodos();
            req.setAttribute("listaAnimais", listaAnimais);

            // Carregar veterinários
            List<Veterinario> vets = new VeterinarioDAO().listarTodos();
            req.setAttribute("listaVets", vets);

            // Abrir JSP de agendamento geral
            req.getRequestDispatcher("rececionista/agendarServicoGeral.jsp").forward(req, resp);
            return;
        }

        // Se a ação for "gerir" (Agendar para um animal específico vindo da lista)
        if ("gerir".equals(action)) {
            try {
                String idStr = req.getParameter("idPaciente");
                if (idStr == null || idStr.isEmpty()) {
                    resp.sendRedirect("rececionista/menuRece.jsp");
                    return;
                }
                int idPaciente = Integer.parseInt(idStr);

                Paciente p = new PacienteDAO().findById(idPaciente);
                if (p == null) {
                    resp.sendRedirect("rececionista/gerirAnimal.jsp?msg=erroEncontrar");
                    return;
                }
                req.setAttribute("animal", p);

                AgendamentoDAO dao = new AgendamentoDAO();
                List<ServicoMedicoAgendamento> lista = dao.listarPorAnimal(idPaciente);
                req.setAttribute("listaAgendamentos", lista);

                List<Veterinario> vets = new VeterinarioDAO().listarTodos();
                req.setAttribute("listaVets", vets);

                req.getRequestDispatcher("rececionista/agendarServico.jsp").forward(req, resp);

            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect("rececionista/gerirAnimal.jsp?msg=erro");
            }
        } else {
            resp.sendRedirect("rececionista/gerirAnimal.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        AgendamentoDAO dao = new AgendamentoDAO();

        String idPacienteStr = req.getParameter("idPaciente");
        int idPaciente = (idPacienteStr != null && !idPacienteStr.isEmpty()) ? Integer.parseInt(idPacienteStr) : 0;

        try {
            if ("criar".equals(action)) {
                ServicoMedicoAgendamento s = new ServicoMedicoAgendamento(0, null, null);
                s.setDescricao(req.getParameter("descricao"));
                s.setLocalidade(req.getParameter("localidade"));
                s.setIdPaciente(idPaciente);

                // Tratamento seguro do ID Veterinário
                String idVetStr = req.getParameter("idVeterinario");
                if (idVetStr != null && !idVetStr.trim().isEmpty()) {
                    try {
                        s.setIdUtilizador(Integer.parseInt(idVetStr.trim()));
                    } catch (NumberFormatException e) {
                        s.setIdUtilizador(null);
                    }
                }

                String dataStr = req.getParameter("dataHora");
                if (dataStr != null && !dataStr.isEmpty()) {
                    s.setDataHoraAgendada(LocalDateTime.parse(dataStr));
                }

                String tipoServico = req.getParameter("tipoServico");
                dao.criar(s, tipoServico);
            }
            // ... (cancelar e reagendar mantêm-se iguais) ...
            else if ("cancelar".equals(action)) {
                int idServico = Integer.parseInt(req.getParameter("idServico"));
                dao.cancelar(idServico);
            } else if ("reagendar".equals(action)) {
                int idServico = Integer.parseInt(req.getParameter("idServico"));
                String novaDataStr = req.getParameter("novaDataHora");
                dao.reagendar(idServico, LocalDateTime.parse(novaDataStr));
            }

            resp.sendRedirect("AgendamentoServlet?action=gerir&idPaciente=" + idPaciente + "&msg=sucesso");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("AgendamentoServlet?action=gerir&idPaciente=" + idPaciente + "&msg=erroBD");
        }
    }
}