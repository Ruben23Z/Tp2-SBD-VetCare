package servlet;

import dao.AgendamentoDAO;
import dao.PacienteDAO;
import dao.VeterinarioDAO;
import model.Paciente.Paciente;
import model.ServicoMedicoAgendamento;
import model.Utilizador.Veterinario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/AgendamentoServlet")
public class AgendamentoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("novo".equals(action)) {
            try {
                // Carregar lista de animais para o dropdown
                List<Paciente> listaAnimais = new PacienteDAO().listarTodos();
                req.setAttribute("listaAnimais", listaAnimais);

                // Carregar veterinários para a cábula
                List<Veterinario> vets = new VeterinarioDAO().listarTodos();
                req.setAttribute("listaVets", vets);

                // Carregar a lista global de agendamentos (Futuros/Recentes)
                List<ServicoMedicoAgendamento> agendaGeral = new AgendamentoDAO().listarTodosFuturos();
                req.setAttribute("agendaGeral", agendaGeral);

                req.getRequestDispatcher("rececionista/agendarServicoGeral.jsp").forward(req, resp);
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect("rececionista/menuRece.jsp?msg=erroCarregar");
            }
            return;
        }

        // 2. PÁGINA: GERIR AGENDAMENTOS DE UM ANIMAL ESPECÍFICO (Vindo de "Gerir Animais")
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

                // Carregar histórico específico deste animal
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

        // Recuperar ID do Paciente (Necessário para a criação e para o redirect "gerir")
        String idPacienteStr = req.getParameter("idPaciente");
        int idPaciente = (idPacienteStr != null && !idPacienteStr.isEmpty()) ? Integer.parseInt(idPacienteStr) : 0;

        String origem = req.getParameter("origem");
        String redirectUrl;

        if ("geral".equals(origem)) {
            redirectUrl = "AgendamentoServlet?action=novo"; // Volta para a Agenda Global
        } else {
            redirectUrl = "AgendamentoServlet?action=gerir&idPaciente=" + idPaciente; // Volta para o Animal
        }

        try {
            // --- AÇÃO: CRIAR AGENDAMENTO ---
            if ("criar".equals(action)) {
                ServicoMedicoAgendamento s = new ServicoMedicoAgendamento(0, null, null);
                s.setDescricao(req.getParameter("descricao"));
                s.setLocalidade(req.getParameter("localidade"));
                s.setIdPaciente(idPaciente);

                // Tratamento do ID Veterinário
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

                // Ao criar, usamos o redirectUrl definido acima
                resp.sendRedirect(redirectUrl + "&msg=sucesso");
            }

            // --- AÇÃO: CANCELAR ---
            else if ("cancelar".equals(action)) {
                int idServico = Integer.parseInt(req.getParameter("idServico"));
                dao.cancelar(idServico);

                resp.sendRedirect(redirectUrl + "&msg=cancelado");
            }

            // --- AÇÃO: REAGENDAR ---
            else if ("reagendar".equals(action)) {
                int idServico = Integer.parseInt(req.getParameter("idServico"));
                String novaDataStr = req.getParameter("novaDataHora");

                if (novaDataStr != null && !novaDataStr.isEmpty()) {
                    dao.reagendar(idServico, LocalDateTime.parse(novaDataStr));
                    resp.sendRedirect(redirectUrl + "&msg=reagendado");
                } else {
                    resp.sendRedirect(redirectUrl + "&msg=erroData");
                }
            }

            // --- AÇÃO: ATIVAR (Confirmar Presença) ---
            else if ("ativar".equals(action)) {
                int idServico = Integer.parseInt(req.getParameter("idServico"));
                dao.ativar(idServico);

                resp.sendRedirect(redirectUrl + "&msg=ativado");
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Fallback em caso de erro crítico
            if (idPaciente > 0) {
                resp.sendRedirect("AgendamentoServlet?action=gerir&idPaciente=" + idPaciente + "&msg=erroBD");
            } else {
                resp.sendRedirect("rececionista/menuRece.jsp?msg=erroCritico");
            }
        }
    }
}