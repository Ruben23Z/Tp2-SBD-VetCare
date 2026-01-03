<%@ page import="model.Utilizador.Veterinario" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Veterinario> vets = (List<Veterinario>) request.getAttribute("vets");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="pt">
<head>
    <title>Gerir Horários</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; padding: 20px; background: #f4f4f9; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { color: #333; margin-top: 0; }
        label { display: block; margin-top: 15px; font-weight: bold; color: #555; }
        select, button { width: 100%; padding: 10px; margin-top: 5px; border-radius: 4px; border: 1px solid #ddd; }
        button { background-color: #667eea; color: white; border: none; cursor: pointer; font-weight: bold; margin-top: 20px; }
        button:hover { background-color: #5a6fd6; }
        .back-link { text-decoration: none; color: #666; margin-bottom: 20px; display: inline-block; }
        .alert { padding: 10px; margin-bottom: 20px; border-radius: 4px; text-align: center; }
        .success { background-color: #d4edda; color: #155724; }
        .error { background-color: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
<div class="container">
    <a href="GerenteServlet?action=dashboard" class="back-link">← Voltar ao Menu</a>
    <h2>📅 Atribuir Supervisão (Horários)</h2>

    <% if ("sucesso".equals(msg)) { %>
    <div class="alert success">Horário atribuído com sucesso!</div>
    <% } else if ("erroConflito".equals(msg)) { %>
    <div class="alert error">Erro: Sobreposição de horários ou dia inválido (Fim de semana).</div>
    <% } else if ("erroBD".equals(msg)) { %>
    <div class="alert error">Erro ao comunicar com a base de dados.</div>
    <% } %>

    <form action="GerenteServlet" method="post">
        <input type="hidden" name="action" value="atribuirHorario">

        <label>Veterinário:</label>
        <select name="nLicenca" required>
            <option value="">Selecione um veterinário...</option>
            <% if(vets != null) for(Veterinario v : vets) { %>
            <option value="<%= v.getnLicenca() %>"><%= v.getNome() %> (Lic: <%= v.getnLicenca() %>)</option>
            <% } %>
        </select>

        <label>Clínica:</label>
        <select name="localidade">
            <option value="Serpa">Serpa</option>
            <option value="Odivelas">Odivelas</option>
            <option value="Quinta do Conde">Quinta do Conde</option>
        </select>

        <label>Dia da Semana:</label>
        <select name="diaUtil">
            <option value="SEG">Segunda-feira</option>
            <option value="TER">Terça-feira</option>
            <option value="QUA">Quarta-feira</option>
            <option value="QUI">Quinta-feira</option>
            <option value="SEX">Sexta-feira</option>
        </select>

        <button type="submit">Atribuir Horário</button>
    </form>
</div>
</body>
</html>