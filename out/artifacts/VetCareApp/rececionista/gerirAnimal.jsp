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
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestão de Animais - VetCare</title>
    <style>
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
            grid-template-columns: 400px 1fr;
            gap: 20px;
        }

        /* ALERTAS */
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

        /* FORMULÁRIO */
        .form-section {
            background: #fff;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            height: fit-content;
            position: sticky;
            top: 20px;
        }

        .form-section h3 {
            color: #667eea;
            font-size: 22px;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }

        input, select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
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

        input[type="file"] {
            padding: 10px;
            cursor: pointer;
        }

        .current-photo {
            margin: 10px 0;
            text-align: center;
        }

        .current-photo img {
            max-width: 100px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            border: 3px solid #fff;
        }

        .current-photo small {
            display: block;
            color: #666;
            margin-top: 5px;
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
            margin-top: 10px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-cancel {
            background: #f0f0f0;
            color: #666;
            width: 100%;
            margin-top: 10px;
        }

        .btn-cancel:hover {
            background: #e0e0e0;
        }

        /* LISTA */
        .list-section {
            background: #fff;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .list-section h3 {
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

        tbody tr {
            transition: background 0.2s;
        }

        tbody tr:hover {
            background: #f8f9ff;
        }

        tbody tr:last-child td:first-child {
            border-radius: 0 0 0 10px;
        }

        tbody tr:last-child td:last-child {
            border-radius: 0 0 10px 0;
        }

        .img-thumb {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid #f0f0f0;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .no-photo {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-edit {
            background: #2196F3;
            color: white;
            padding: 8px 15px;
            font-size: 13px;
        }

        .btn-edit:hover {
            background: #1976D2;
            transform: translateY(-2px);
        }

        .btn-delete {
            background: #f44336;
            color: white;
            padding: 8px 15px;
            font-size: 13px;
        }

        .btn-delete:hover {
            background: #da190b;
            transform: translateY(-2px);
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
            }
        }

        @media (max-width: 768px) {
            .page-header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
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
</head>
<body>

<div class="page-header">
    <h1><span>🐾</span> Gestão de Animais</h1>
    <a href="rececionista/menuRece.jsp" class="back-link">← Voltar ao Menu</a>
</div>

<%-- BLOCO DE MENSAGENS --%>
<% if ("sucesso".equals(msg)) { %>
<div class="alert success"> Sucesso: Operação realizada com êxito!</div>
<% } else if ("criado".equals(msg)) { %>
<div class="alert success"> Sucesso: Novo animal registado!</div>
<% } else if ("atualizado".equals(msg)) { %>
<div class="alert success"> Sucesso: Dados do animal atualizados!</div>
<% } else if ("eliminado".equals(msg)) { %>
<div class="alert success"> Sucesso: Animal eliminado do sistema.</div>
<% } else if ("erroNIF".equals(msg)) { %>
<div class="alert error"> Erro: O NIF do Tutor não existe! Crie o Cliente primeiro.</div>
<% } else if ("erroRaca".equals(msg)) { %>
<div class="alert error"> Erro: A Raça selecionada é inválida.</div>
<% } else if ("erroEliminar".equals(msg)) { %>
<div class="alert error"> Erro ao Eliminar: Não pode apagar este animal porque tem histórico (Consultas/Família)
    associado.
</div>
<% } else if ("erro".equals(msg)) { %>
<div class="alert error">Erro genérico no servidor. Verifique os dados.</div>
<% } %>

<div class="container">
    <!-- FORMULÁRIO -->
    <div class="form-section">
        <h3>
            <% if (edit != null) { %>
            <span>✏️</span> Editar Animal
            <% } else { %>
            <span>➕</span> Novo Animal
            <% } %>
        </h3>

        <form action="${pageContext.request.contextPath}/AnimalServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="acao" value="salvar">
            <input type="hidden" name="idPaciente" value="<%= (edit != null) ? edit.getidPaciente() : "0" %>">
            <input type="hidden" name="fotoAtual"
                   value="<%= (edit != null && edit.getFoto() != null) ? edit.getFoto() : "" %>">

            <div class="form-group">
                <label>Nome do Animal</label>
                <input type="text" name="nome" value="<%= (edit != null) ? edit.getNome() : "" %>" required
                       placeholder="Ex: Max, Luna">
            </div>

            <div class="form-group">
                <label>Data de Nascimento</label>
                <input type="date" name="dataNascimento"
                       value="<%= (edit != null) ? edit.getDataNascimento() : "" %>" required>
            </div>

            <div class="form-group">
                <label>NIF do Tutor</label>
                <input type="text" name="nif" value="<%= (edit != null) ? edit.getNifDono() : "" %>" required
                       pattern="[0-9]{9}" title="Deve ter 9 dígitos" placeholder="123456789">
            </div>

            <div class="form-group">
                <label>Raça</label>
                <select name="raca" required>
                    <option value="" disabled <%= (edit == null) ? "selected" : "" %>>Selecione a raça...</option>
                    <optgroup label="🐕 Cães">
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
                    </optgroup>
                    <optgroup label="🐈 Gatos">
                        <option value="Siamês" <%= (edit != null && "Siamês".equals(edit.getRaca())) ? "selected" : "" %>>
                            Siamês
                        </option>
                    </optgroup>
                    <optgroup label="🦜 Outros">
                        <option value="Papagaio Cinzento" <%= (edit != null && "Papagaio Cinzento".equals(edit.getRaca())) ? "selected" : "" %>>
                            Papagaio Cinzento
                        </option>
                    </optgroup>
                </select>
            </div>

            <div class="form-group">
                <label>Peso (Kg)</label>
                <input type="number" step="0.1" name="peso" value="<%= (edit != null) ? edit.getPesoAtual() : "" %>"
                       required placeholder="Ex: 12.5">
            </div>

            <div class="form-group">
                <label>Sexo</label>
                <select name="sexo">
                    <option value="M" <%= (edit != null && edit.getSexo() == 'M') ? "selected" : "" %>>🐕 Macho
                    </option>
                    <option value="F" <%= (edit != null && edit.getSexo() == 'F') ? "selected" : "" %>>🐕 Fêmea
                    </option>
                </select>
            </div>

            <div class="form-group">
                <label>Fotografia</label>
                <% if (edit != null && edit.getFoto() != null && !edit.getFoto().isEmpty()) { %>
                <div class="current-photo">
                    <img src="${pageContext.request.contextPath}/<%= edit.getFoto() %>" alt="Foto atual">
                    <small>Carregue nova foto para substituir</small>
                </div>
                <% } %>
                <input type="file" name="foto" accept="image/*">
            </div>

            <button type="submit" class="btn btn-submit">
                <%= (edit != null) ? "Atualizar Dados" : "Registar Animal" %>
            </button>

            <% if (edit != null) { %>
            <a href="${pageContext.request.contextPath}/AnimalServlet?acao=listar" class="btn btn-cancel"> Cancelar
                Edição</a>
            <% } %>
        </form>
    </div>

    <!-- LISTA -->
    <div class="list-section">
        <h3><span>📋</span> Lista de Animais Registados</h3>
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
                    <img src="${pageContext.request.contextPath}/<%= p.getFoto() %>" class="img-thumb"
                         alt="<%= p.getNome() %>">
                    <% } else { %>
                    <div class="no-photo">🐾</div>
                    <% } %>
                </td>
                <td><strong><%= p.getNome() %>
                </strong></td>
                <td><%= p.getRaca() %>
                </td>
                <td><%= p.getNifDono() %>
                </td>
                <td><%= p.getDataNascimento() %>
                </td>
                <td>
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/AnimalServlet?acao=editar&id=<%= p.getidPaciente() %>"
                           class="btn btn-edit"> Editar</a>
                        <a href="${pageContext.request.contextPath}/AnimalServlet?acao=eliminar&id=<%= p.getidPaciente() %>"
                           class="btn btn-delete"
                           onclick="return confirm('Tem a certeza que deseja eliminar <%= p.getNome() %>?');">
                            Eliminar</a>
                    </div>
                </td>
            </tr>
            <% }
            } else { %>
            <tr>
                <td colspan="6">
                    <div class="empty-state">
                        <div class="icon">🐾</div>
                        <h3>Nenhum animal registado</h3>
                        <p>Comece por adicionar o primeiro animal usando o formulário ao lado.</p>
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