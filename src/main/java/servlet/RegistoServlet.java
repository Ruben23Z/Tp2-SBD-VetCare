package servlet;

import dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Utilizador.*;

import java.io.IOException;

@WebServlet("/registo")
public class RegistoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String cargo = req.getParameter("cargo");
            boolean cli = "Cliente".equals(cargo);
            boolean vet = "Veterinario".equals(cargo);
            boolean rec = "Rececionista".equals(cargo);
            boolean ger = "Gerente".equals(cargo);

            // ===== UTILIZADOR =====
            Utilizador u = new Utilizador(vet, rec, cli, ger, req.getParameter("username"), req.getParameter("password"));
            UtilizadorDAO udao = new UtilizadorDAO();
            int idUtilizador = udao.inserir(u);

            // ===== CLIENTE =====
            if (cli) {
                String telefone = req.getParameter("telefone").trim();
                if (!telefone.matches("^\\+[0-9]{1,4} [0-9]{9}$")) throw new ServletException("Telefone inválido.");
                String nif = req.getParameter("nif");
                System.out.println( "NIF OBTIDO"+nif);
                if(nif == null || nif.trim().isEmpty() || !nif.matches("\\d{9}")) {
                    throw new ServletException("NIF inválido ou não preenchido");
                }
                nif = nif.trim();

                String nome = req.getParameter("nomeCliente");
                String email = req.getParameter("email");
                String rua = req.getParameter("rua");
                String pais = req.getParameter("pais");
                String distrito = req.getParameter("distrito");
                String concelho = req.getParameter("concelho");
                String freguesia = req.getParameter("freguesia");

                Cliente c = new Cliente(idUtilizador, nif, nome, email, telefone, rua, pais, distrito, concelho, freguesia);
                new ClienteDAO().inserir(c, idUtilizador);

                String tipo = req.getParameter("tipoCliente");
                if ("Particular".equals(tipo)) {
                    String pref = req.getParameter("prefLinguistica");
                    Particular p = new Particular(nif, pref.isEmpty() ? null : pref);
                    new ParticularDAO().inserir(p);
                } else if ("Empresa".equals(tipo)) {
                    String capitalStr = req.getParameter("capitalSocial");
                    if (capitalStr == null || capitalStr.isEmpty())
                        throw new ServletException("Capital social obrigatório.");
                    Empresa e = new Empresa(nif, Integer.parseInt(capitalStr));
                    new EmpresaDAO().inserir(e);
                }
            }

            // ===== VETERINARIO =====
            if (vet) {
                Veterinario v = new Veterinario(idUtilizador, "LIC-" + idUtilizador, req.getParameter("nomeVet"), Integer.parseInt(req.getParameter("idade")), req.getParameter("especialidade"));
                new VeterinarioDAO().inserir(v, idUtilizador);
            }

            // ===== RECECIONISTA =====
            if (rec) new RececionistaDAO().inserir(idUtilizador);

            // ===== GERENTE =====
            if (ger) new GerenteDAO().inserir(idUtilizador);

            resp.sendRedirect("login.jsp?registo=ok");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("registo.jsp?erro=1");
        }
    }
}
