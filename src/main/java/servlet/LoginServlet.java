package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.ClienteDAO;
import dao.VeterinarioDAO;
import dao.RececionistaDAO;

import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Recebe os parâmetros do formulário
        String tipoUtilizador = request.getParameter("tipoUtilizador");
        String usuario = request.getParameter("usuario");
        String senha = request.getParameter("senha");

        boolean autenticado = false;

        // Validar login conforme tipo de utilizador
        switch (tipoUtilizador) {
            case "cliente":
                ClienteDAO tutorDAO = new ClienteDAO();
                autenticado = tutorDAO.login(usuario, senha);
                break;
            case "veterinario":
                VeterinarioDAO vetDAO = new VeterinarioDAO();
                autenticado = vetDAO.login(usuario, senha);
                break;
            case "rececionista":
                RececionistaDAO recDAO = new RececionistaDAO();
                autenticado = recDAO.login(usuario, senha);
                break;
            default:
                autenticado = false;
        }

        // Se login válido, cria sessão e redireciona
        if (autenticado) {
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);
            session.setAttribute("tipoUtilizador", tipoUtilizador);

            switch (tipoUtilizador) {
                case "cliente":
                    response.sendRedirect("tutor/consultar.jsp");
                    break;
                case "veterinario":
                    response.sendRedirect("veterinario/fichaAnimal.jsp");
                    break;
                case "rececionista":
                    response.sendRedirect("rececionista/menuRece.jsp");
                    break;
            }
        } else {
            // Se login falhou, redireciona de volta com erro
            response.sendRedirect("login.jsp?erro=1");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redireciona GET para login.jsp
        response.sendRedirect("login.jsp");
    }
}
