<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <title>Menu Gerente</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; padding: 20px; background: #f4f4f9; }
        .menu-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px; max-width: 1000px; margin: 20px auto; }
        .card { background: white; padding: 20px; border-radius: 8px; text-align: center; box-shadow: 0 2px 5px rgba(0,0,0,0.1); text-decoration: none; color: #333; transition: 0.2s; }
        .card:hover { transform: translateY(-3px); box-shadow: 0 5px 15px rgba(0,0,0,0.1); background: #eef2ff; }
        .card h3 { color: #667eea; margin-bottom: 10px; }
        .section-title { grid-column: 1 / -1; margin-top: 20px; border-bottom: 2px solid #ddd; padding-bottom: 5px; color: #555; }
    </style>
</head>
<body>
<div style="display:flex; justify-content:space-between; align-items:center;">
    <h1>🏢 Painel de Gestão</h1>
    <a href="../logout.jsp" style="color:red; font-weight:bold; text-decoration:none;">Sair</a>
</div>

<div class="menu-grid">
    <div class="section-title">👥 Gestão de Pessoal e Entidades (4.1)</div>
    <a href="GerenteServlet?action=listarVets" class="card">
        <h3>🩺 Veterinários</h3>
        <p>Criar e editar perfis</p>
    </a>
    <a href="GerenteServlet?action=gerirTutores" class="card">
        <h3>👥 Tutores e Animais</h3>
        <p>Aceder à gestão global</p>
    </a>

    <div class="section-title">📅 Operações (4.2 - 4.4)</div>
    <a href="GerenteServlet?action=horarios" class="card">
        <h3>⏰ Gestão de Horários</h3>
        <p>Atribuir supervisão</p>
    </a>
    <a href="GerenteServlet?action=exportImport" class="card">
        <h3>💾 Importar / Exportar</h3>
        <p>JSON/XML de Fichas</p>
    </a>

    <div class="section-title">📊 Estatísticas e Relatórios (4.5 - 4.8)</div>
    <a href="GerenteServlet?action=statsVida" class="card">
        <h3>👵 Expectativa de Vida</h3>
        <p>Animais acima da média</p>
    </a>
    <a href="GerenteServlet?action=statsPeso" class="card">
        <h3>⚖️ Excesso de Peso</h3>
        <p>Tutores com animais obesos</p>
    </a>
    <a href="GerenteServlet?action=statsCancel" class="card">
        <h3>🚫 Cancelamentos</h3>
        <p>Top tutores (3 meses)</p>
    </a>
    <a href="GerenteServlet?action=statsSemana" class="card">
        <h3>📈 Previsão Semanal</h3>
        <p>Serviços agendados</p>
    </a>
</div>
</body>
</html>