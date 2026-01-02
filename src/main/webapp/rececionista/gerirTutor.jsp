<%@ page import="java.util.List" %>
<%@ page import="dao.ClienteDAO" %>
<%@ page import="model.Utilizador.Cliente" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Recuperar objeto de edição se existir e a lista
    Cliente edit = (Cliente) request.getAttribute("clienteEditar");
    List<Cliente> clientes = (List<Cliente>) request.getAttribute("listaClientes");

    // Se a lista for nula (acesso direto pelo menu), vai buscar à BD
    if (clientes == null) {
        ClienteDAO dao = new ClienteDAO();
        clientes = dao.findAll();
    }
%>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestão de Clientes - VetCare</title>
    <style>
        /* O teu CSS original (mantido para poupar espaço) */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .page-header {
            max-width: 1400px;
            margin: 0 auto 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #fff;
            padding: 20px 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .page-header h1 {
            color: #667eea;
            font-size: 28px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .back-link {
            text-decoration: none;
            color: #666;
            padding: 10px 20px;
            border-radius: 8px;
            background: #f0f0f0;
            transition: all 0.3s;
            font-weight: 600;
        }

        .back-link:hover {
            background: #e0e0e0;
            transform: translateY(-2px);
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 450px 1fr;
            gap: 20px;
        }

        .alert {
            max-width: 1400px;
            margin: 0 auto 20px;
            padding: 15px 20px;
            border-radius: 10px;
            color: white;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert.success {
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
        }

        .alert.error {
            background: linear-gradient(135deg, #f44336 0%, #da190b 100%);
        }

        .form-section {
            background: #fff;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            height: fit-content;
            position: sticky;
            top: 20px;
            max-height: calc(100vh - 40px);
            overflow-y: auto;
        }

        .form-section h2 {
            color: #667eea;
            font-size: 22px;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .section-title {
            color: #667eea;
            font-size: 16px;
            margin: 20px 0 12px 0;
            padding-bottom: 8px;
            border-bottom: 1px solid #f0f0f0;
            font-weight: 600;
        }

        .form-group {
            margin-bottom: 16px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            color: #333;
            font-weight: 600;
            font-size: 13px;
        }

        input, select {
            width: 100%;
            padding: 10px 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: #f9f9f9;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #667eea;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .info-badge {
            display: inline-block;
            background: #e8f0fe;
            color: #667eea;
            padding: 3px 10px;
            border-radius: 10px;
            font-size: 11px;
            font-weight: 600;
            margin-left: 6px;
        }

        .conditional-field {
            display: none;
        }

        .btn {
            padding: 12px 20px;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            width: 100%;
            margin-top: 15px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-cancel {
            background: #999;
            color: white;
            width: 100%;
            margin-top: 10px;
        }

        .list-section {
            background: #fff;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .list-section h2 {
            color: #667eea;
            font-size: 22px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 10px;
        }

        thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        th {
            padding: 15px;
            text-align: left;
            color: white;
            font-weight: 600;
            font-size: 14px;
        }

        th:first-child {
            border-radius: 10px 0 0 0;
        }

        th:last-child {
            border-radius: 0 10px 0 0;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
            color: #333;
        }

        tbody tr:hover {
            background: #f8f9ff;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .action-buttons form {
            margin: 0;
        }

        .btn-edit {
            background: #2196F3;
            color: white;
            padding: 8px 15px;
            font-size: 13px;
        }

        .btn-delete {
            background: #f44336;
            color: white;
            padding: 8px 15px;
            font-size: 13px;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .empty-state .icon {
            font-size: 64px;
            margin-bottom: 15px;
            opacity: 0.5;
        }

        @media (max-width: 1200px) {
            .container {
                grid-template-columns: 1fr;
            }

            .form-section {
                position: relative;
                top: 0;
                max-height: none;
            }
        }

        @media (max-width: 768px) {
            .page-header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            table {
                font-size: 12px;
            }

            th, td {
                padding: 10px 8px;
            }

            .action-buttons {
                flex-direction: column;
            }
        }
    </style>

    <script>
        function toggleConditionalFields() {
            const tipo = document.getElementById('tipoCliente').value;
            const empresaField = document.getElementById('empresaField');
            const particularField = document.getElementById('particularField');

            if (tipo === 'Empresa') {
                empresaField.style.display = 'block';
                particularField.style.display = 'none';
                document.getElementById('capitalSocial').required = true;
                document.getElementById('prefLinguistica').required = false;
            } else {
                empresaField.style.display = 'none';
                particularField.style.display = 'block';
                document.getElementById('capitalSocial').required = false;
                document.getElementById('prefLinguistica').required = false;
            }
        }

        window.onload = function () {
            toggleConditionalFields();
        };
    </script>
</head>
<body>

<div class="page-header">
    <h1><span>👥</span> Gestão de Clientes</h1>
    <a href="rececionista/menuRece.jsp" class="back-link">← Voltar ao Menu</a>
</div>

<%-- Mensagens de sucesso/erro --%>
<%
    String ok = request.getParameter("ok");
    String erro = request.getParameter("erro");
    if ("1".equals(ok)) { %>
<div class="alert success"> Operação realizada com sucesso!</div>
<% } else if ("1".equals(erro)) { %>
<div class="alert error"> Ocorreu um erro. Tente novamente.</div>
<% } %>

<div class="container">
    <div class="form-section">
        <h2><span><%= (edit != null) ? "✏️ Editar" : "➕ Adicionar" %></span> Cliente</h2>

        <form action="<%= request.getContextPath() %>/RececionistaServlet" method="post">

            <input type="hidden" name="action" value="<%= (edit != null) ? "atualizarCliente" : "criarCliente" %>">
            <input type="hidden" name="cargo" value="Cliente">

            <% if (edit != null) { %>
            <input type="hidden" name="idUtilizador" value="<%= edit.getiDUtilizador() %>">
            <% } %>

            <% if (edit == null) { %>
            <div class="section-title">Dados de Acesso</div>
            <div class="form-row">
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" required placeholder="Username único">
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" required minlength="6" placeholder="Mínimo 6 caracteres">
                </div>
            </div>
            <% } %>

            <% if (edit == null) { %>
            <div class="section-title"> Tipo de Cliente</div>
            <div class="form-group">
                <label>Tipo de Cliente</label>
                <select name="tipoCliente" id="tipoCliente" required onchange="toggleConditionalFields()">
                    <option value="Particular">Particular</option>
                    <option value="Empresa">Empresa</option>
                </select>
            </div>
            <% } %>

            <div class="section-title">Dados Pessoais</div>

            <div class="form-group">
                <label>Nome Completo / Razão Social</label>
                <input type="text" name="nomeCliente" required placeholder="Nome completo"
                       value="<%= (edit != null) ? edit.getNome() : "" %>">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>NIF</label>
                    <input type="text" name="nif" pattern="\d{9}" required title="9 dígitos" placeholder="123456789"
                           value="<%= (edit != null) ? edit.getNIF() : "" %>">
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" required placeholder="exemplo@email.com"
                           value="<%= (edit != null) ? edit.getEmail() : "" %>">
                </div>
            </div>

            <div class="form-group">
                <label>Telefone</label>
                <input type="tel" name="telefone" pattern="\+[0-9]{1,4} [0-9]{9}" placeholder="+351 912345678" required
                       value="<%= (edit != null && edit.getTelefone() != null) ? edit.getTelefone() : "" %>">
            </div>

            <div class="section-title">Morada</div>

            <div class="form-group">
                <label>Rua</label>
                <input type="text" name="rua" required placeholder="Rua e número"
                       value="<%= (edit != null) ? edit.getRua() : "" %>">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>País</label>
                    <input type="text" name="pais" required value="<%= (edit != null) ? edit.getPais() : "Portugal" %>">
                </div>

                <div class="form-group">
                    <label>Distrito</label>
                    <input type="text" name="distrito" required placeholder="Ex: Lisboa"
                           value="<%= (edit != null) ? edit.getDistrito() : "" %>">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Concelho</label>
                    <input type="text" name="concelho" required placeholder="Ex: Sintra"
                           value="<%= (edit != null) ? edit.getConcelho() : "" %>">
                </div>

                <div class="form-group">
                    <label>Freguesia</label>
                    <input type="text" name="freguesia" required placeholder="Ex: São João"
                           value="<%= (edit != null) ? edit.getFreguesia() : "" %>">
                </div>
            </div>

            <% if (edit == null) { %>
            <div class="section-title">Informações Específicas</div>
            <div id="empresaField" class="form-group conditional-field">
                <label>Capital Social (€)</label>
                <input type="number" name="capitalSocial" id="capitalSocial" min="1" step="0.01"
                       placeholder="Ex: 50000">
            </div>
            <div id="particularField" class="form-group conditional-field">
                <label>Preferência Linguística <span class="info-badge">Opcional</span></label>
                <input type="text" name="prefLinguistica" id="prefLinguistica" placeholder="Ex: Português, Inglês">
            </div>
            <% } %>

            <button type="submit" class="btn btn-submit">
                <%= (edit != null) ? "Guardar Alterações" : "Criar Cliente" %>
            </button>

            <% if (edit != null) { %>
            <a href="rececionista/gerirTutor.jsp" class="btn btn-cancel">Cancelar Edição</a>
            <% } %>
        </form>
    </div>

    <div class="list-section">
        <h2><span>📋</span> Lista de Clientes</h2>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Nome</th>
                <th>NIF</th>
                <th>Email</th>
                <th>Telefone</th>
                <th>Ações</th>
            </tr>
            </thead>
            <tbody>
            <%
                if (clientes != null && !clientes.isEmpty()) {
                    for (Cliente c : clientes) {
            %>
            <tr>
                <td><strong><%= c.getiDUtilizador() %>
                </strong></td>
                <td><%= c.getNome() %>
                </td>
                <td><%= c.getNIF() %>
                </td>
                <td><%= c.getEmail() %>
                </td>
                <td><%= c.getTelefone() != null ? c.getTelefone() : "-" %>
                </td>
                <td>
                    <div class="action-buttons">
                        <form action="<%= request.getContextPath() %>/RececionistaServlet" method="get">
                            <input type="hidden" name="action" value="editarCliente">
                            <input type="hidden" name="idUtilizador" value="<%= c.getiDUtilizador() %>">
                            <button type="submit" class="btn btn-edit">✏️ Editar</button>
                        </form>

                    </div>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="6">
                    <div class="empty-state">
                        <div class="icon">👥</div>
                        <h3>Nenhum cliente registado</h3>
                        <p>Comece por adicionar o primeiro cliente.</p>
                    </div>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>