package servlet;

import dao.UtilizadorDAO;
import model.Utilizador.Utilizador;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.*;

import java.io.File;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            UtilizadorDAO dao = new UtilizadorDAO();
            Utilizador u = dao.findByUsernameAndPassword(username, password);
            System.out.println(u);
            System.out.println("senha: " + password);
            System.out.println("user:" + username);

            if (u == null) {
                response.sendRedirect("login.jsp?erro=1");
                return;
            }

            String cargo;
            if (u.isGerente()) cargo = "Gerente";
            else if (u.isRececionista()) cargo = "Rececionista";
            else if (u.isVeterinario()) cargo = "Veterinario";
            else if (u.isCliente()) cargo = "Cliente";
            else {
                response.sendRedirect("login.jsp?erro=3");
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("utilizador", u);
            session.setAttribute("cargo", cargo);

            String ctx = request.getContextPath();
            switch (cargo) {
                case "Gerente":
                    response.sendRedirect(ctx + "/gerente/criarAtualizarVet.jsp");
                    break;
                case "Rececionista":
                    response.sendRedirect(ctx + "/rececionista/menuRece.jsp");
                    break;
                case "Veterinario":
                    response.sendRedirect(ctx + "/veterinario/fichaAnimal.jsp");
                    break;
                case "Cliente":
                    response.sendRedirect(ctx + "/TutorServlet?action=dashboard");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?erro=1");
        }
    }

    // Autenticação no XML
    private Integer autenticarXML(String user, String pass, HttpServletRequest request) {

        try {
            String path = request.getServletContext().getRealPath("/WEB-INF/UtilizadoresXML.xml");

            File xml = new File(path);

            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse(xml);

            NodeList lista = doc.getElementsByTagName("utilizador");

            for (int i = 0; i < lista.getLength(); i++) {
                Element e = (Element) lista.item(i);

                String u = e.getElementsByTagName("username").item(0).getTextContent();
                String p = e.getElementsByTagName("password").item(0).getTextContent();

                if (u.equals(user) && p.equals(pass)) {
                    return Integer.parseInt(e.getElementsByTagName("idUtilizador").item(0).getTextContent());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
