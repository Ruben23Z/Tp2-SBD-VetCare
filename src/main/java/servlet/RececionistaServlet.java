package servlet;

import dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Animal;
import model.Utilizador.Cliente;
import model.Utilizador.Empresa;
import model.Utilizador.Particular;
import model.Utilizador.Utilizador;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/RececionistaServlet")
@MultipartConfig
public class RececionistaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, RuntimeException {
        String action = req.getParameter("action");
        ClienteDAO dao = new ClienteDAO();
        try {
            if ("editarCliente".equals(action)) {
                String idStr = req.getParameter("idUtilizador");
                if (idStr != null && !idStr.isBlank()) {
                    int id = Integer.parseInt(idStr);
                    // 1. Buscar os dados do cliente
                    Cliente c = null;
                    c = dao.findById(id);
                    // 2. Enviar para o JSP preencher o formulário
                    req.setAttribute("clienteEditar", c);
                    // 3. Carregar a lista também para a tabela não desaparecer
                    List<Cliente> lista = null; // Método que tens no DAO
                    try {
                        lista = dao.findAll();
                    } catch (SQLException e) {
                        throw new RuntimeException(e);
                    }
                    req.setAttribute("listaClientes", lista);
                    req.getRequestDispatcher("/rececionista/gerirTutor.jsp").forward(req, resp);                    return;
                }
            }
            // Se não for edição, apenas redireciona para a página limpa (que carrega a lista sozinha)
            resp.sendRedirect("rececionista/gerirTutor.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("rececionista/menuRece.jsp?erro=1");
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws
            ServletException, IOException {

        String action = req.getParameter("action");

        try {

            if ("salvarAnimal".equals(action)) {
                String clienteNIF = req.getParameter("clienteNIF");
                Cliente c = new ClienteDAO().findByNif(Integer.parseInt(clienteNIF));
                if (c == null) throw new ServletException("Cliente não encontrado!");

                Part filePart = req.getPart("foto");
                String fotoPath = "/uploads/" + filePart.getSubmittedFileName();
                filePart.write(getServletContext().getRealPath(fotoPath));

                java.sql.Date data = java.sql.Date.valueOf(req.getParameter("dataNascimento"));
                Animal a = new Animal(0, c.getiDUtilizador(), req.getParameter("nome"), req.getParameter("especie"), req.getParameter("raca"), data, fotoPath);

                new AnimalDAO().inserir(a);
                resp.sendRedirect("rececionista/gerirAnimais.jsp?ok=1");
            } else if ("agendarServico".equals(action)) {
                int idPaciente = Integer.parseInt(req.getParameter("idPaciente"));
                LocalDateTime dataHora = LocalDateTime.parse(req.getParameter("dataHora"));

                new ServicoDAO().criarServico(req.getParameter("descricao"), dataHora, idPaciente, Integer.parseInt(req.getParameter("idUtilizador")), req.getParameter("localidade"));

                resp.sendRedirect("rececionista/agendarServico.jsp?ok=1");

            } else if ("eliminarCliente".equals(action)) {

                String idStr = req.getParameter("idUtilizador");

                if (idStr == null || idStr.isBlank()) {
                    throw new ServletException("ID do utilizador não foi enviado");
                }

                int idUtilizador = Integer.parseInt(idStr);

                ClienteDAO clienteDAO = new ClienteDAO();
                AnimalDAO animalDAO = new AnimalDAO();
                ServicoDAO servicoDAO = new ServicoDAO();
                ParticularDAO particularDAO = new ParticularDAO();
                EmpresaDAO empresaDAO = new EmpresaDAO();
                UtilizadorDAO utilizadorDAO = new UtilizadorDAO();

                Cliente c = clienteDAO.findById(idUtilizador);
                if (c == null) {
                    throw new ServletException("Cliente não encontrado");
                }

                // Apagar serviços dos animais do cliente
                servicoDAO.deleteByCliente(idUtilizador);

                Cliente cliente = clienteDAO.findById(idUtilizador); // obténs iDUtilizador
                String nif = cliente.getNIF(); // pega o NIF
                animalDAO.deleteByCliente(nif); // agora funciona

                // Apagar subtipo
                particularDAO.deleteByNif(c.getNIF());
                empresaDAO.deleteByNif(c.getNIF());

                // Apagar cliente
                clienteDAO.delete(idUtilizador);

                // Apagar utilizador
                utilizadorDAO.delete(idUtilizador);

                req.setAttribute("ok", "Cliente eliminado com sucesso");

                req.getRequestDispatcher("/WEB-INF/rececionista/gerirClientes.jsp").forward(req, resp);

            } else if ("criarCliente".equals(action)) {

                // ===== UTILIZADOR =====
                Utilizador u = new Utilizador(false, false, true, false, req.getParameter("username"), req.getParameter("password"));

                int idUtilizador = new UtilizadorDAO().inserir(u);

                // ===== TELEFONE (corrigido) =====
                String telefone = req.getParameter("telefone");
                if (telefone != null && !telefone.isBlank()) {
                    telefone = telefone.trim();
                    if (!telefone.matches("^\\+[0-9]{1,4} [0-9]{9}$"))
                        throw new ServletException("Telefone inválido.");
                } else {
                    telefone = null;
                }

                // ===== CLIENTE =====
                Cliente c = new Cliente(idUtilizador, req.getParameter("nif").trim(), req.getParameter("nomeCliente"), req.getParameter("email"), telefone, req.getParameter("rua"), req.getParameter("pais"), req.getParameter("distrito"), req.getParameter("concelho"), req.getParameter("freguesia"));

                new ClienteDAO().inserir(c, idUtilizador);

                // ===== TIPO =====
                String tipo = req.getParameter("tipoCliente");

                if ("Particular".equals(tipo)) {
                    String pref = req.getParameter("prefLinguistica");
                    new ParticularDAO().inserir(new Particular(c.getNIF(), pref == null || pref.isBlank() ? null : pref));
                }

                if ("Empresa".equals(tipo)) {
                    int capital = Integer.parseInt(req.getParameter("capitalSocial"));
                    new EmpresaDAO().inserir(new Empresa(c.getNIF(), capital));
                }

                resp.sendRedirect("rececionista/gerirTutor.jsp?ok=1");
            } else if ("editarCliente".equals(action)) {
                int id = Integer.parseInt(req.getParameter("idUtilizador"));
                resp.sendRedirect("rececionista/editarCliente.jsp?idUtilizador=" + id);
            } else if ("atualizarCliente".equals(action)) {

                Cliente c = new Cliente(Integer.parseInt(req.getParameter("idUtilizador")), req.getParameter("nif"), req.getParameter("nomeCliente"), req.getParameter("email"), req.getParameter("telefone"), req.getParameter("rua"), req.getParameter("pais"), req.getParameter("distrito"), req.getParameter("concelho"), req.getParameter("freguesia"));

                new ClienteDAO().update(c);

                resp.sendRedirect("rececionista/gerirTutor.jsp?ok=1");
            }


        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
