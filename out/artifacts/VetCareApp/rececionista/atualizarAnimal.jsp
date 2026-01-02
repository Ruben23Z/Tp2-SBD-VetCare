<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Paciente" %>
<!DOCTYPE html>
<html>
<head>
    <title>Editar Animal</title>
</head>
<body>
<% Paciente p = (Paciente) request.getAttribute("animal"); %>

<h2>Editar: <%= (p != null) ? p.getNome() : "Erro" %></h2>

<% if (p != null) { %>
<form action="${pageContext.request.contextPath}/AnimalServlet" method="post" enctype="multipart/form-data">
    <input type="hidden" name="action" value="atualizar">
    <input type="hidden" name="idPaciente" value="<%= p.getidPaciente() %>">
    <input type="hidden" name="fotoAtual" value="<%= (p.getFoto() != null) ? p.getFoto() : "" %>">

    <label>Nome:</label> <input type="text" name="nome" value="<%= p.getNome() %>" required><br><br>
    <label>NIF Tutor:</label> <input type="text" name="nif" value="<%= p.getNifDono() %>" required><br><br>
    <label>Raça:</label> <input type="text" name="raca" value="<%= p.getRaca() %>" required><br><br>
    <label>Data Nasc:</label> <input type="date" name="dataNascimento" value="<%= p.getDataNascimento() %>" required><br><br>
    <label>Peso:</label> <input type="number" step="0.1" name="peso" value="<%= p.getPesoAtual() %>" required><br><br>

    <label>Sexo:</label>
    <select name="sexo">
        <option value="M" <%= "M".equals(p.getSexo()) ? "selected" : "" %>>Macho</option>
        <option value="F" <%= "F".equals(p.getSexo()) ? "selected" : "" %>>Fêmea</option>
    </select><br><br>

    <% if(p.getFoto() != null) { %>
    <p>Foto atual:</p>
    <img src="${pageContext.request.contextPath}/<%= p.getFoto() %>" width="100"><br>
    <% } %>

    <label>Alterar Foto:</label> <input type="file" name="foto" accept="image/*"><br><br>

    <button type="submit">Atualizar Animal</button>
</form>
<% } else { %>
<p>Erro: Animal não encontrado.</p>
<% } %>
</body>
</html>