package servlet.users;

import dao.PacienteDAO;
import model.Paciente.Paciente;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/AnimalServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AnimalServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String acao = request.getParameter("acao");
        PacienteDAO dao = new PacienteDAO();

        // 1. Ação de Listar (Padrão)
        if (acao == null || "listar".equals(acao)) {
            String filtroNIF = request.getParameter("filtroNIF");
            String origem = request.getParameter("origem"); // "gerente" ou null

            List<Paciente> lista;
            if (filtroNIF != null && !filtroNIF.isEmpty()) {
                lista = dao.listarPorNif(filtroNIF);
                request.setAttribute("filtroNIF", filtroNIF); // Para manter no form de criar novo
            } else {
                lista = dao.listarTodos();
            }

            request.setAttribute("listaAnimais", lista);
            request.setAttribute("origem", origem); // Passar para o JSP saber para onde voltar

            request.getRequestDispatcher("/rececionista/gerirAnimal.jsp").forward(request, response);
        } else if ("editar".equals(acao)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Paciente p = dao.findById(id);
                request.setAttribute("animalEditar", p);

                // Recarregar a lista para mostrar a tabela em baixo
                List<Paciente> lista = dao.listarTodos();
                request.setAttribute("listaAnimais", lista);

                request.getRequestDispatcher("rececionista/gerirAnimal.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect("AnimalServlet?acao=listar&msg=erroID");
            }

        } else if ("eliminar".equals(acao)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.delete(id);
                response.sendRedirect("AnimalServlet?acao=listar&msg=eliminado");
            } catch (SQLException e) {
                // Erro de FK (tem agendamentos)
                response.sendRedirect("AnimalServlet?acao=listar&msg=erroEliminar");
            } catch (NumberFormatException e) {
                response.sendRedirect("AnimalServlet?acao=listar&msg=erro");
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String acao = request.getParameter("acao");
        PacienteDAO dao = new PacienteDAO();

        if ("salvar".equals(acao)) {
            try {
                Paciente p = new Paciente();

                String idStr = request.getParameter("idPaciente");
                int id = (idStr == null || idStr.isEmpty()) ? 0 : Integer.parseInt(idStr);
                p.setiDPaciente(id);

                p.setNome(request.getParameter("nome"));
                String transponder = request.getParameter("transponder");
                if (transponder != null && !transponder.trim().isEmpty()) {
                    p.setTransponder(transponder);
                } else {
                    p.setTransponder(null); // Permite nulo se não preenchido
                }
                // --- VALIDAÇÃO DO NIF DO DONO ---
                String nifDono = request.getParameter("nif");
                // Verificar se o cliente existe
                if (new dao.ClienteDAO().findByNif(Integer.parseInt(nifDono)) == null) {
                    // Se não existir, redireciona com erro
                    response.sendRedirect("AnimalServlet?acao=listar&msg=erroNIF");
                    return;
                }
                p.setNifDono(nifDono);
                p.setRaca(request.getParameter("raca"));

                String pesoStr = request.getParameter("peso");
                if (pesoStr != null && !pesoStr.isEmpty()) p.setPesoAtual(Double.parseDouble(pesoStr));

                String sexoStr = request.getParameter("sexo");
                if (sexoStr != null && !sexoStr.isEmpty()) p.setSexo(sexoStr.charAt(0));

                String dataStr = request.getParameter("dataNascimento");
                if (dataStr != null && !dataStr.isEmpty()) p.setDataNascimento(LocalDate.parse(dataStr));

                String obitoStr = request.getParameter("dataObito");
                if (obitoStr != null && !obitoStr.isEmpty()) {
                    p.setDataObito(LocalDate.parse(obitoStr));
                } else {
                    p.setDataObito(null);
                }

                // Upload de Foto
                String novaFoto = processarUpload(request);
                if (novaFoto != null) {
                    p.setFoto(novaFoto);
                } else {
                    p.setFoto(request.getParameter("fotoAtual"));
                }

                if (id == 0) {
                    dao.insert(p);
                    response.sendRedirect("AnimalServlet?acao=listar&msg=criado");
                } else {
                    dao.atualizar(p);
                    response.sendRedirect("AnimalServlet?acao=listar&msg=atualizado");
                }

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("AnimalServlet?acao=listar&msg=erro");
            }
        }
    }

    private String processarUpload(HttpServletRequest request) {
        try {
            Part filePart = request.getPart("foto");
            if (filePart == null || filePart.getSize() == 0) return null;
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            if (fileName == null || fileName.isEmpty()) return null;

            // Caminho relativo para guardar
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            String novoNome = System.currentTimeMillis() + "_" + fileName;
            filePart.write(uploadPath + File.separator + novoNome);
            return "uploads/" + novoNome;
        } catch (Exception e) {
            return null;
        }
    }
}