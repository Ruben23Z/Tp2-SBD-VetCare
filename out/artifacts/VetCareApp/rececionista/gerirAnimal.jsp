<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Paciente" %>
<%
    // 1. Recuperar dados do Servlet
    List<Paciente> lista = (List<Paciente>) request.getAttribute("listaAnimais");
    Paciente edit = (Paciente) request.getAttribute("animalEditar");
    String msg = request.getParameter("msg");

    // 2. Se a lista vier nula (acesso direto), pede ao Servlet para carregar
    if (lista == null && request.getParameter("redirecionado") == null) {
        response.sendRedirect(request.getContextPath() + "/AnimalServlet?acao=listar&redirecionado=true");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Gestão de Animais</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
        }

        .container {
            display: flex;
            gap: 20px;
        }

        .form-section {
            flex: 1;
            padding: 20px;
            border: 1px solid #ccc;
            background: #f9f9f9;
            border-radius: 8px;
        }

        .list-section {
            flex: 2;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #4CAF50;
            color: white;
        }

        img.thumb {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 50%;
        }

        /* Mensagens */
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            color: white;
        }

        .success {
            background-color: #4CAF50;
        }

        .error {
            background-color: #f44336;
        }

        /* Botões */
        .btn {
            padding: 8px 15px;
            cursor: pointer;
            text-decoration: none;
            color: white;
            border: none;
            border-radius: 4px;
            display: inline-block;
            margin-top: 5px;
        }

        .btn-submit {
            background-color: #4CAF50;
            width: 100%;
            font-size: 16px;
        }

        .btn-cancel {
            background-color: #777;
            width: 100%;
            text-align: center;
            box-sizing: border-box;
        }

        .btn-edit {
            background-color: #2196F3;
            font-size: 12px;
        }

        .btn-del {
            background-color: #f44336;
            font-size: 12px;
        }
    </style>
</head>
<body>

<h1>Gestão de Animais</h1>
<a href="rececionista/menuRece.jsp" style="text-decoration: none; color: #333;">&larr; Voltar ao Menu</a>
<br><br>

<%-- BLOCO DE MENSAGENS (Lógica corrigida) --%>
<% if ("sucesso".equals(msg)) { %>
<div class="alert success">Sucesso: Operação realizada com êxito!</div>
<% } else if ("criado".equals(msg)) { %>
<div class="alert success">Sucesso: Novo animal registado!</div>
<% } else if ("atualizado".equals(msg)) { %>
<div class="alert success">Sucesso: Dados do animal atualizados!</div>
<% } else if ("eliminado".equals(msg)) { %>
<div class="alert success">Sucesso: Animal eliminado do sistema.</div>
<% } else if ("erroNIF".equals(msg)) { %>
<div class="alert error"><strong>Erro:</strong> O NIF do Tutor não existe! Crie o Cliente primeiro.</div>
<% } else if ("erroRaca".equals(msg)) { %>
<div class="alert error"><strong>Erro:</strong> A Raça selecionada é inválida.</div>
<% } else if ("erroEliminar".equals(msg)) { %>
<div class="alert error"><strong>Erro ao Eliminar:</strong> Não pode apagar este animal porque tem histórico
    (Consultas/Família) associado.
</div>
<% } else if ("erro".equals(msg)) { %>
<div class="alert error">Erro genérico no servidor. Verifique os dados.</div>
<% } %>

<div class="container">

    <div class="form-section">
        <h3 style="margin-top: 0;"><%= (edit != null) ? "Editar Animal" : "Novo Animal" %>
        </h3>

        <form action="${pageContext.request.contextPath}/AnimalServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="acao" value="salvar">
            <input type="hidden" name="idPaciente" value="<%= (edit != null) ? edit.getidPaciente() : "0" %>">
            <input type="hidden" name="fotoAtual"
                   value="<%= (edit != null && edit.getFoto() != null) ? edit.getFoto() : "" %>">

            <label>Nome:</label><br>
            <input type="text" name="nome" style="width: 95%; padding: 5px;"
                   value="<%= (edit != null) ? edit.getNome() : "" %>" required><br><br>

            <label>Data de Nascimento:</label><br>
            <input type="date" name="dataNascimento" style="width: 95%; padding: 5px;"
                   value="<%= (edit != null) ? edit.getDataNascimento() : "" %>" required><br><br>

            <label>NIF do Tutor:</label><br>
            <input type="text" name="nif" style="width: 95%; padding: 5px;"
                   value="<%= (edit != null) ? edit.getNifDono() : "" %>" required pattern="[0-9]{9}"
                   title="Deve ter 9 dígitos"><br><br>

            <label>Raça:</label><br>
            <select name="raca" style="width: 100%; padding: 5px;" required>
                <option value="" disabled <%= (edit == null) ? "selected" : "" %>>Selecione...</option>
                <%-- CÃES --%>
                <option value="Labrador" <%= (edit != null && "Labrador".equals(edit.getRaca())) ? "selected" : "" %>>
                    Labrador
                </option>
                <option value="Golden Retriever" <%= (edit != null && "Golden Retriever".equals(edit.getRaca())) ? "selected" : "" %>>
                    Golden Retriever
                </option>
                <option value="Pastor Alemão" <%= (edit != null && "Pastor Alemão".equals(edit.getRaca())) ? "selected" : "" %>>
                    Pastor Alemão
                </option>
                <option value="Beagle" <%= (edit != null && "Beagle".equals(edit.getRaca())) ? "selected" : "" %>>
                    Beagle
                </option>
                <option value="Bulldog Francês" <%= (edit != null && "Bulldog Francês".equals(edit.getRaca())) ? "selected" : "" %>>
                    Bulldog Francês
                </option>
                <%-- GATOS --%>
                <option value="Siamês" <%= (edit != null && "Siamês".equals(edit.getRaca())) ? "selected" : "" %>>
                    Siamês
                </option>
                <%-- OUTROS --%>
                <option value="Papagaio Cinzento" <%= (edit != null && "Papagaio Cinzento".equals(edit.getRaca())) ? "selected" : "" %>>
                    Papagaio Cinzento
                </option>
            </select><br><br>

            <label>Peso (Kg):</label><br>
            <input type="number" step="0.1" name="peso" style="width: 95%; padding: 5px;"
                   value="<%= (edit != null) ? edit.getPesoAtual() : "" %>" required><br><br>

            <label>Sexo:</label><br>
            <select name="sexo" style="width: 100%; padding: 5px;">
                <option value="M" <%= (edit != null && edit.getSexo() == 'M') ? "selected" : "" %>>Macho</option>
                <option value="F" <%= (edit != null && edit.getSexo() == 'F') ? "selected" : "" %>>Fêmea</option>
            </select><br><br>

            <label>Foto:</label><br>
            <% if (edit != null && edit.getFoto() != null) { %>
            <img src="${pageContext.request.contextPath}/<%= edit.getFoto() %>" width="80"
                 style="margin-bottom: 5px;"><br>
            <small>Carregue nova para substituir</small><br>
            <% } %>
            <input type="file" name="foto" accept="image/*"><br><br>

            <button type="submit" class="btn btn-submit">
                <%= (edit != null) ? "Atualizar Dados" : "Registar Animal" %>
            </button>

            <% if (edit != null) { %>
            <a href="${pageContext.request.contextPath}/AnimalServlet?acao=listar" class="btn btn-cancel">Cancelar
                Edição</a>
            <% } %>
        </form>
    </div>

    <div class="list-section">
        <h3>Lista de Animais Registados</h3>
        <table>
            <thead>
            <tr>
                <th>Foto</th>
                <th>Nome</th>
                <th>Raça</th>
                <th>Tutor (NIF)</th>
                <th>Nascimento</th>
                <th>Ações</th>
            </tr>
            </thead>
            <tbody>
            <% if (lista != null && !lista.isEmpty()) {
                for (Paciente p : lista) { %>
            <tr>
                <td>
                    <% if (p.getFoto() != null && !p.getFoto().isEmpty()) { %>
                    <img src="${pageContext.request.contextPath}/<%= p.getFoto() %>" class="thumb">
                    <% } else { %>
                    <span style="font-size:small; color:grey">--</span>
                    <% } %>
                </td>
                <td><%= p.getNome() %>
                </td>
                <td><%= p.getRaca() %>
                </td>
                <td><%= p.getNifDono() %>
                </td>
                <td><%= p.getDataNascimento() %>
                </td>
                <td>
                    <a href="${pageContext.request.contextPath}/AnimalServlet?acao=editar&id=<%= p.getidPaciente() %>"
                       class="btn btn-edit">Editar</a>
                    <a href="${pageContext.request.contextPath}/AnimalServlet?acao=eliminar&id=<%= p.getidPaciente() %>"
                       class="btn btn-del"
                       onclick="return confirm('Tem a certeza que deseja eliminar o <%= p.getNome() %>?');">X</a>
                </td>
            </tr>
            <% }
            } else { %>
            <tr>
                <td colspan="6" style="text-align: center; padding: 20px;">Nenhum animal encontrado.</td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>