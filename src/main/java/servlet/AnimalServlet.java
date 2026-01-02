package servlet;

import dao.PacienteDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Paciente;


import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/AnimalServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AnimalServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ServletException {
        String acao = request.getParameter("acao");
        PacienteDAO dao = new PacienteDAO();

        // 1. Ação de Listar (Padrão)
        if (acao == null || "listar".equals(acao)) {
            List<Paciente> lista = dao.listarTodos();
            request.setAttribute("listaAnimais", lista);
            // Reencaminha sempre para o mesmo JSP único
            request.getRequestDispatcher("rececionista/gerirAnimal.jsp").forward(request, response);

            // 2. Ação de Editar (Preenche o form no mesmo JSP)
        } else if ("editar".equals(acao)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Paciente p = null;
            p = dao.findById(id);
            request.setAttribute("animalEditar", p); // Envia o animal para o form

            // Carrega a lista na mesma para a tabela de baixo não desaparecer
            List<Paciente> lista = dao.listarTodos();
            request.setAttribute("listaAnimais", lista);

            request.getRequestDispatcher("rececionista/gerirAnimal.jsp").forward(request, response);

            // 3. Ação de Eliminar
        } else if ("eliminar".equals(acao)) {
            int id = Integer.parseInt(request.getParameter("id"));
            try {
                dao.delete(id);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
            response.sendRedirect("AnimalServlet?acao=listar&msg=eliminado");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String acao = request.getParameter("acao");
        PacienteDAO dao = new PacienteDAO();

        if ("salvar".equals(acao)) {
            try {
                // Conversão de dados do Form para o Modelo
                Paciente p = new Paciente();

                String idStr = request.getParameter("idPaciente");
                int id = (idStr == null || idStr.isEmpty()) ? 0 : Integer.parseInt(idStr);
                p.setiDPaciente(id);

                p.setNome(request.getParameter("nome"));
                p.setNifDono(request.getParameter("nif"));
                p.setRaca(request.getParameter("raca"));

                // Converter String para double
                String pesoStr = request.getParameter("peso");
                if (pesoStr != null && !pesoStr.isEmpty()) {
                    p.setPesoAtual(Double.parseDouble(pesoStr));
                }

                // Converter String para char
                String sexoStr = request.getParameter("sexo");
                if (sexoStr != null && !sexoStr.isEmpty()) {
                    p.setSexo(sexoStr.charAt(0));
                }

                // Converter String para LocalDate
                String dataStr = request.getParameter("dataNascimento");
                if (dataStr != null && !dataStr.isEmpty()) {
                    p.setDataNascimento(LocalDate.parse(dataStr));
                }

                // Lógica da Foto
                String novaFoto = processarUpload(request);
                if (novaFoto != null) {
                    p.setFoto(novaFoto);
                } else {
                    // Se estiver a editar e não carregar foto nova, mantém a antiga
                    p.setFoto(request.getParameter("fotoAtual"));
                }

                // Decidir se é Insert ou Update
                if (id == 0) {
                    dao.insert(p); // Cria novo
                } else {
                    dao.atualizar(p); // Atualiza existente
                }

                response.sendRedirect("AnimalServlet?acao=listar&msg=sucesso");

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("AnimalServlet?acao=listar&msg=erro");
            }
        }
    }

    private String processarUpload(HttpServletRequest request) throws IOException, ServletException {
        Part filePart = request.getPart("foto");
        if (filePart == null || filePart.getSize() == 0) return null;

        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        if (fileName == null || fileName.isEmpty()) return null;

        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        String novoNome = System.currentTimeMillis() + "_" + fileName;
        filePart.write(uploadPath + File.separator + novoNome);

        return "uploads/" + novoNome;
    }
}