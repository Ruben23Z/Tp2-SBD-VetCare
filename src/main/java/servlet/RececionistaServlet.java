package servlet;

import dao.*;
import model.Utilizador.*;
import model.Paciente; // Atualizado de Animal para Paciente
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/RececionistaServlet")
@MultipartConfig
public class RececionistaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        ClienteDAO dao = new ClienteDAO();

        try {
            // 1. CARREGAR LISTA DE CLIENTES (Ação do Menu)
            if ("gerirClientes".equals(action) || action == null) {
                List<Cliente> lista = dao.findAll();
                req.setAttribute("listaClientes", lista);
                // IMPORTANTE: Usar forward em vez de redirect para manter os dados
                req.getRequestDispatcher("/rececionista/gerirTutor.jsp").forward(req, resp);
                return;
            }

            // 2. EDITAR CLIENTE
            else if ("editarCliente".equals(action)) {
                String idStr = req.getParameter("idUtilizador");
                if (idStr != null && !idStr.isBlank()) {
                    int id = Integer.parseInt(idStr);
                    Cliente c = dao.findById(id);
                    req.setAttribute("clienteEditar", c);

                    // Carregar a lista também para a tabela em baixo não desaparecer
                    List<Cliente> lista = dao.findAll();
                    req.setAttribute("listaClientes", lista);

                    req.getRequestDispatcher("/rececionista/gerirTutor.jsp").forward(req, resp);
                    return;
                }
            }

            // Fallback
            resp.sendRedirect("rececionista/menuRece.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("rececionista/menuRece.jsp?erro=1");
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            // Nota: A gestão de animais agora deve ser feita preferencialmente pelo AnimalServlet
            // Mas mantive aqui a lógica atualizada para 'Paciente' caso ainda uses este endpoint
            if ("salvarAnimal".equals(action)) {
                String clienteNIF = req.getParameter("clienteNIF");
                Cliente c = new ClienteDAO().findByNif(Integer.parseInt(clienteNIF));
                if (c == null) throw new ServletException("Cliente não encontrado!");

                Part filePart = req.getPart("foto");
                String fotoPath = null;
                if (filePart != null && filePart.getSize() > 0) {
                    fotoPath = "/uploads/" + filePart.getSubmittedFileName();
                    filePart.write(getServletContext().getRealPath(fotoPath));
                }

                // ATUALIZADO: Usar Paciente em vez de Animal
                Paciente p = new Paciente();
                p.setNifDono(c.getNIF());
                p.setNome(req.getParameter("nome"));
                p.setRaca(req.getParameter("raca"));
                p.setDataNascimento(java.time.LocalDate.parse(req.getParameter("dataNascimento")));
                p.setFoto(fotoPath);

                new PacienteDAO().insert(p); // Atualizado para PacienteDAO
                resp.sendRedirect("AnimalServlet?acao=listar&ok=1");

            } else if ("agendarServico".equals(action)) {
                int idPaciente = Integer.parseInt(req.getParameter("idPaciente"));
                LocalDateTime dataHora = LocalDateTime.parse(req.getParameter("dataHora"));

                // Atualizado para usar o AgendamentoDAO (mais robusto que o ServicoDAO simples)
                model.ServicoMedicoAgendamento s = new model.ServicoMedicoAgendamento(0, req.getParameter("descricao"), null);
                s.setIdPaciente(idPaciente);
                s.setDataHoraAgendada(dataHora);
                s.setLocalidade(req.getParameter("localidade"));

                // Nota: Requer idVeterinario e tipoServico, ajusta conforme o teu form
                new dao.AgendamentoDAO().criar(s, "Consulta");

                resp.sendRedirect("AgendamentoServlet?action=gerir&idPaciente=" + idPaciente + "&msg=sucesso");

            } else if ("eliminarCliente".equals(action)) {
                String idStr = req.getParameter("idUtilizador");
                if (idStr == null || idStr.isBlank()) throw new ServletException("ID em falta");

                int idUtilizador = Integer.parseInt(idStr);
                ClienteDAO clienteDAO = new ClienteDAO();
                Cliente c = clienteDAO.findById(idUtilizador);

                if (c != null) {
                    // Apagar dependências (Cascade manual se a BD não tiver)
                    // new PacienteDAO().deleteByNif(c.getNIF()); // Precisas de criar este método no PacienteDAO se a BD não apagar em cascata

                    new ParticularDAO().deleteByNif(c.getNIF());
                    new EmpresaDAO().deleteByNif(c.getNIF());
                    clienteDAO.delete(idUtilizador);
                    new UtilizadorDAO().delete(idUtilizador);
                }

                // Redireciona para o controller para recarregar a lista
                resp.sendRedirect("RececionistaServlet?action=gerirClientes&ok=1");

            } else if ("criarCliente".equals(action)) {
                // ===== UTILIZADOR =====
                Utilizador u = new Utilizador(false, false, true, false, req.getParameter("username"), req.getParameter("password"));
                int idUtilizador = new UtilizadorDAO().inserir(u);

                // ===== TELEFONE =====
                String telefone = req.getParameter("telefone");
                if (telefone != null && !telefone.isBlank()) {
                    telefone = telefone.trim();
                    // Validação simples ou regex
                }

                // ===== CLIENTE =====
                Cliente c = new Cliente(idUtilizador, req.getParameter("nif").trim(), req.getParameter("nomeCliente"), req.getParameter("email"), telefone, req.getParameter("rua"), req.getParameter("pais"), req.getParameter("distrito"), req.getParameter("concelho"), req.getParameter("freguesia"));
                new ClienteDAO().inserir(c, idUtilizador);

                // ===== TIPO =====
                String tipo = req.getParameter("tipoCliente");
                if ("Particular".equals(tipo)) {
                    String pref = req.getParameter("prefLinguistica");
                    new ParticularDAO().inserir(new Particular(c.getNIF(), pref));
                } else if ("Empresa".equals(tipo)) {
                    int capital = 0;
                    try { capital = Integer.parseInt(req.getParameter("capitalSocial")); } catch(Exception e){}
                    new EmpresaDAO().inserir(new Empresa(c.getNIF(), capital));
                }

                resp.sendRedirect("RececionistaServlet?action=gerirClientes&ok=criado");

            } else if ("atualizarCliente".equals(action)) {
                Cliente c = new Cliente(
                        Integer.parseInt(req.getParameter("idUtilizador")),
                        req.getParameter("nif"),
                        req.getParameter("nomeCliente"),
                        req.getParameter("email"),
                        req.getParameter("telefone"),
                        req.getParameter("rua"),
                        req.getParameter("pais"),
                        req.getParameter("distrito"),
                        req.getParameter("concelho"),
                        req.getParameter("freguesia")
                );
                new ClienteDAO().update(c);
                resp.sendRedirect("RececionistaServlet?action=gerirClientes&ok=atualizado");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("rececionista/menuRece.jsp?erro=1");
        }
    }
}