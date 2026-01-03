<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% List<Map<String, Object>> dados = (List<Map<String, Object>>) request.getAttribute("dados"); %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <title>Estatística Peso</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; padding: 20px; background: #f4f4f9; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { color: #333; border-bottom: 2px solid #e91e63; padding-bottom: 10px; margin-top: 0; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #f8f9fa; }
        .count-badge { background: #e91e63; color: white; padding: 5px 10px; border-radius: 20px; font-weight: bold; font-size: 14px; }
    </style>
</head>
<body>
<div class="container">
    <a href="GerenteServlet?action=dashboard" style="text-decoration:none; color:#666;">← Voltar</a>
    <h2>⚖️ Tutores com animais com excesso de peso</h2>
    <p style="color:#666; font-size:14px; margin-bottom:20px;">Lista ordenada alfabeticamente por nome do tutor.</p>

    <% if (dados == null || dados.isEmpty()) { %>
    <p>Não foram encontrados animais com peso acima da média da raça.</p>
    <% } else { %>
    <table>
        <thead>
        <tr>
            <th>Nome do Tutor</th>
            <th style="text-align: center;">Qtd. Animais (Excesso Peso)</th>
        </tr>
        </thead>
        <tbody>
        <% for(Map<String, Object> row : dados) { %>
        <tr>
            <td><%= row.get("nomeTutor") %></td>
            <td style="text-align: center;">
                <span class="count-badge"><%= row.get("qtdAnimais") %></span>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>
</div>
</body>
</html>