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

        // 1. PÁGINA: NOVO AGENDAMENTO GERAL (Escolher animal numa lista)
        if ("novo".equals(action)) {
            try {
                // Carregar lista de animais para o dropdown
                List<Paciente> listaAnimais = new PacienteDAO().listarTodos();
                req.setAttribute("listaAnimais", listaAnimais);

                // Carregar veterinários
                List<Veterinario> vets = new VeterinarioDAO().listarTodos();
                req.setAttribute("listaVets", vets);

                req.getRequestDispatcher("rececionista/agendarServicoGeral.jsp").forward(req, resp);
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect("rececionista/menuRece.jsp?msg=erroCarregar");
            }
            return;
        }

        // 2. PÁGINA: GERIR AGENDAMENTOS DE UM ANIMAL (Histórico + Agendar)
        if ("gerir".equals(action)) {
            try {
                String idStr = req.getParameter("idPaciente");
                if (idStr == null || idStr.isEmpty()) {
                    resp.sendRedirect("rececionista/menuRece.jsp");
                    return;
                }
                int idPaciente = Integer.parseInt(idStr);

                // Carregar dados do animal
                Paciente p = new PacienteDAO().findById(idPaciente);
                if (p == null) {
                    resp.sendRedirect("rececionista/gerirAnimal.jsp?msg=erroEncontrar");
                    return;
                }
                req.setAttribute("animal", p);

                // Carregar histórico
                AgendamentoDAO dao = new AgendamentoDAO();
                List<ServicoMedicoAgendamento> lista = dao.listarPorAnimal(idPaciente);
                req.setAttribute("listaAgendamentos", lista);

                // Carregar veterinários
                List<Veterinario> vets = new VeterinarioDAO().listarTodos();
                req.setAttribute("listaVets", vets);

                req.getRequestDispatcher("rececionista/agendarServico.jsp").forward(req, resp);

            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect("rececionista/gerirAnimal.jsp?msg=erro");
            }
        } else {
            // Se nenhuma ação válida, volta ao menu
            resp.sendRedirect("rececionista/menuRece.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        AgendamentoDAO dao = new AgendamentoDAO();

        // Recuperar ID do Paciente (Obrigatório para redirecionar de volta à página certa)
        String idPacienteStr = req.getParameter("idPaciente");
        int idPaciente = (idPacienteStr != null && !idPacienteStr.isEmpty()) ? Integer.parseInt(idPacienteStr) : 0;

        try {
            // --- AÇÃO: CRIAR ---
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

                resp.sendRedirect("AgendamentoServlet?action=gerir&idPaciente=" + idPaciente + "&msg=sucesso");
            }

            // --- AÇÃO: CANCELAR ---
            else if ("cancelar".equals(action)) {
                int idServico = Integer.parseInt(req.getParameter("idServico"));
                dao.cancelar(idServico);

                resp.sendRedirect("AgendamentoServlet?action=gerir&idPaciente=" + idPaciente + "&msg=cancelado");
            }

            // --- AÇÃO: REAGENDAR ---
            else if ("reagendar".equals(action)) {
                int idServico = Integer.parseInt(req.getParameter("idServico"));
                String novaDataStr = req.getParameter("novaDataHora");

                if (novaDataStr != null && !novaDataStr.isEmpty()) {
                    dao.reagendar(idServico, LocalDateTime.parse(novaDataStr));
                    resp.sendRedirect("AgendamentoServlet?action=gerir&idPaciente=" + idPaciente + "&msg=reagendado");
                } else {
                    resp.sendRedirect("AgendamentoServlet?action=gerir&idPaciente=" + idPaciente + "&msg=erroData");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Em caso de erro, tenta voltar à página do animal
            if (idPaciente > 0) {
                resp.sendRedirect("AgendamentoServlet?action=gerir&idPaciente=" + idPaciente + "&msg=erroBD");
            } else {
                resp.sendRedirect("rececionista/menuRece.jsp?msg=erroCritico");
            }
        }
    }
}