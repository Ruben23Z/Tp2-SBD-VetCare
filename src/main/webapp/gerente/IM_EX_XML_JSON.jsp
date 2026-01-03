<%@ page import="model.Paciente.Paciente" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Paciente> animais = (List<Paciente>) request.getAttribute("animais");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="pt">
<head>
    <title>Importar/Exportar</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; padding: 20px; background: #f4f4f9; }
        .container { display: flex; gap: 20px; max-width: 1000px; margin: 0 auto; }
        .box { flex: 1; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { margin-top: 0; color: #333; border-bottom: 2px solid #eee; padding-bottom: 10px; }
        ul { list-style: none; padding: 0; max-height: 400px; overflow-y: auto; }
        li { padding: 10px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center; }
        .btn-down { background: #4CAF50; color: white; padding: 5px 10px; text-decoration: none; border-radius: 4px; font-size: 12px; }
        textarea { width: 100%; height: 200px; padding: 10px; margin-top: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        .btn-action { width: 100%; padding: 10px; background: #667eea; color: white; border: none; border-radius: 4px; margin-top: 10px; cursor: pointer; }
        .alert { padding: 10px; margin-bottom: 20px; background: #d4edda; color: #155724; border-radius: 4px; text-align: center; }
    </style>
</head>
<body>
<div style="max-width: 1000px; margin: 0 auto 20px;">
    <a href="GerenteServlet?action=dashboard" style="text-decoration:none; color:#666; font-weight:bold;">← Voltar ao Menu</a>
    <% if ("importado".equals(msg)) { %><div class="alert">Ficha importada com sucesso (Simulação)!</div><% } %>
</div>

<div class="container">
    <div class="box">
        <h2>💾 Exportar Ficha (JSON)</h2>
        <p style="color:#666; font-size:14px;">Selecione um animal para descarregar o ficheiro JSON:</p>
        <ul>
            <% if(animais!=null) for(Paciente p : animais) { %>
            <li>
                <span><strong><%= p.getNome() %></strong> <small>(ID: <%= p.getidPaciente() %>)</small></span>
                <a href="GerenteServlet?action=downloadJSON&idPaciente=<%= p.getidPaciente() %>" class="btn-down">📥 JSON</a>
            </li>
            <% } else { %>
            <li><p>Nenhum animal registado.</p></li>
            <% } %>
        </ul>
    </div>

    <div class="box">
        <h2>📤 Importar Ficha (JSON)</h2>
        <p style="color:#666; font-size:14px;">Cole o conteúdo do ficheiro JSON abaixo:</p>
        <form action="GerenteServlet" method="post">
            <input type="hidden" name="action" value="importarJSON">
            <textarea name="jsonContent" placeholder='Exemplo: {"nome": "Rex", "raca": "Pastor Alemão" ...}' required></textarea>
            <button type="submit" class="btn-action">Importar Ficha</button>
        </form>
    </div>
</div>
</body>
</html>