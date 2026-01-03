package servlet.users;

import dao.AgendamentoDAO;
import dao.PacienteDAO;
import model.Paciente.NoArvore;
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
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/VeterinarioServlet")
public class VeterinarioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();
        Utilizador user = (Utilizador) session.getAttribute("utilizador");

        // Proteção de sessão
        if (user == null || !user.isVeterinario()) {
            resp.sendRedirect("login.jsp");
            return;
        }

        if ("dashboard".equals(action)) {
            req.getRequestDispatcher("veterinario/menuVeterinario.jsp").forward(req, resp);
        }

        // REQUISITO 2.4: LISTA DE CHAMADA
        else if ("listaChamada".equals(action)) {
            System.out.println("DEBUG SERVLET: ID na Sessão = " + user.getiDUtilizador());
            AgendamentoDAO dao = new AgendamentoDAO();
            List<ServicoMedicoAgendamento> agenda = dao.getAgendaVeterinario(user.getiDUtilizador());
            System.out.println("DEBUG SERVLET: Tamanho da lista encontrada = " + agenda.size());
            req.setAttribute("agenda", agenda);
            req.getRequestDispatcher("veterinario/listaChamada.jsp").forward(req, resp);
        }
        // 3. Consultar Ficha Clínica (Dados, Idade, Árvore, Histórico)
        else if ("consultarFicha".equals(action)) {
            try {
                int idPaciente = Integer.parseInt(req.getParameter("idPaciente"));
                PacienteDAO pDao = new PacienteDAO();
                AgendamentoDAO aDao = new AgendamentoDAO();

                // 1. Dados do Animal
                Paciente p = pDao.findById(idPaciente);
                req.setAttribute("animal", p);

                // 2. ÁRVORE GENEALÓGICA (AQUI ESTÁ O SEGREDO)
                NoArvore arvore = pDao.getArvoreCompleta(idPaciente);
                req.setAttribute("arvore", arvore); // Envia para o JSP

                // 3. Histórico
                List<ServicoMedicoAgendamento> historico = aDao.listarPorAnimal(idPaciente);
                req.setAttribute("historico", historico);

                req.getRequestDispatcher("veterinario/fichaAnimal.jsp").forward(req, resp);
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect("VeterinarioServlet?action=dashboard");
            }
        }

        // 4. Autocomplete
        else if ("buscarAnimaisAJAX".equals(action)) {
            String termo = req.getParameter("termo");
            List<Paciente> lista = new PacienteDAO().buscarPorNomeTutor(termo);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            PrintWriter out = resp.getWriter();

            // Construção manual de JSON para evitar dependências externas
            out.print("[");
            for (int i = 0; i < lista.size(); i++) {
                Paciente p = lista.get(i);
                out.print(String.format("{\"id\":%d, \"nome\":\"%s\", \"dono\":\"%s\"}", p.getidPaciente(), p.getNome(), p.getNifDono()));
                if (i < lista.size() - 1) out.print(",");
            }
            out.print("]");
            out.flush();
        }

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        // 5. Atualizar Histórico (Notas Médicas)
        if ("atualizarNotas".equals(action)) {
            try {
                int idServico = Integer.parseInt(req.getParameter("idServico"));
                int idPaciente = Integer.parseInt(req.getParameter("idPaciente"));
                String notas = req.getParameter("notas");

                new AgendamentoDAO().atualizarNotas(idServico, notas);

                // Volta para a ficha do animal
                resp.sendRedirect("VeterinarioServlet?action=consultarFicha&idPaciente=" + idPaciente);
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect("VeterinarioServlet?action=dashboard&msg=erro");
            }
        }
    }
}