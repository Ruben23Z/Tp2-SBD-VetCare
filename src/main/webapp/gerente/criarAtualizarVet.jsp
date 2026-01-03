<%@ page import="model.Utilizador.Veterinario" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Veterinario> vets = (List<Veterinario>) request.getAttribute("vets");
    Veterinario edit = (Veterinario) request.getAttribute("vetEditar");
%>
<!DOCTYPE html>
<html lang="pt">
<head>
    <title>Gestão de Veterinários</title>
    <style>
        body { font-family: sans-serif; padding: 20px; display: flex; gap: 20px; }
        .form-container { width: 35%; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); height: fit-content; }
        .list-container { width: 60%; }
        input, select { width: 100%; padding: 8px; margin: 5px 0 15px; box-sizing: border-box; }
        button { width: 100%; padding: 10px; background: #4CAF50; color: white; border: none; cursor: pointer; }
        table { width: 100%; border-collapse: collapse; background: white; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>

<div class="form-container">
    <a href="GerenteServlet?action=dashboard">← Voltar</a>
    <h2><%= (edit != null) ? "Editar" : "Novo" %> Veterinário</h2>

    <form action="GerenteServlet" method="post">
        <input type="hidden" name="action" value="salvarVet">
        <input type="hidden" name="idUtilizador" value="<%= (edit != null) ? edit.getiDUtilizador() : "0" %>">

        <label>Nº Licença (Único):</label>
        <input type="text" name="nLicenca" required value="<%= (edit!=null)?edit.getnLicenca():"" %>" <%= (edit!=null)?"readonly":"" %>>

        <label>Nome Completo:</label>
        <input type="text" name="nome" required value="<%= (edit!=null)?edit.getNome():"" %>">

        <label>Idade:</label>
        <input type="number" name="idade" required value="<%= (edit!=null)?edit.getIdade():"" %>">

        <label>Especialidade:</label>
        <select name="especialidade">
            <option value="Geral" <%= (edit!=null && "Geral".equals(edit.getEspecialidade()))?"selected":"" %>>Geral</option>
            <option value="Cirurgia" <%= (edit!=null && "Cirurgia".equals(edit.getEspecialidade()))?"selected":"" %>>Cirurgia</option>
            <option value="Dermatologia" <%= (edit!=null && "Dermatologia".equals(edit.getEspecialidade()))?"selected":"" %>>Dermatologia</option>
        </select>

        <% if (edit == null) { %>
        <hr>
        <p><strong>Dados de Acesso:</strong></p>
        <label>Username:</label>
        <input type="text" name="username" required>
        <label>Password:</label>
        <input type="password" name="password" required>
        <% } %>

        <button type="submit">Guardar</button>
        <% if(edit != null) { %> <a href="GerenteServlet?action=listarVets" style="display:block;text-align:center;margin-top:10px;">Cancelar</a> <% } %>
    </form>
</div>

<div class="list-container">
    <h2>Veterinários Registados</h2>
    <table>
        <thead>
        <tr>
            <th>Licença</th>
            <th>Nome</th>
            <th>Especialidade</th>
            <th>Ação</th>
        </tr>
        </thead>
        <tbody>
        <% if(vets != null) for(Veterinario v : vets) { %>
        <tr>
            <td><%= v.getnLicenca() %></td>
            <td><%= v.getNome() %></td>
            <td><%= v.getEspecialidade() %></td>
            <td>
                <a href="GerenteServlet?action=editarVet&licenca=<%= v.getnLicenca() %>">Editar</a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>

</body>
</html>