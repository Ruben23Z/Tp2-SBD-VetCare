<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Paciente.Paciente" %>
<%
    List<Paciente> lista = (List<Paciente>) request.getAttribute("listaAnimais");
    Paciente edit = (Paciente) request.getAttribute("animalEditar");
    String msg = request.getParameter("msg");

    if (lista == null && request.getParameter("redirecionado") == null) {
        response.sendRedirect(request.getContextPath() + "/AnimalServlet?acao=listar&redirecionado=true");
        return;
    }
%>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestão de Animais | VetCare</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.5/font/bootstrap-icons.min.css"
          rel="stylesheet">
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

        .page-container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .page-header {
            background: rgba(255, 255, 255, 0.95);
            padding: 25px 30px;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 20px;
        }

        .page-header h1 {
            color: #2d3748;
            font-size: 28px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .page-header h1 i {
            color: #667eea;
            font-size: 32px;
        }

        .btn-back {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 10px 25px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .alert {
            padding: 16px 24px;
            border-radius: 12px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            animation: slideDown 0.4s ease;
            font-weight: 500;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert i {
            font-size: 24px;
        }

        .alert.success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .alert.error {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        .container {
            display: grid;
            grid-template-columns: 420px 1fr;
            gap: 25px;
        }

        .form-section {
            background: rgba(255, 255, 255, 0.95);
            padding: 35px;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            height: fit-content;
            position: sticky;
            top: 20px;
        }

        .form-section h3 {
            color: #2d3748;
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 3px solid #667eea;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-section h3 i {
            color: #667eea;
            font-size: 24px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 8px;
            color: #2d3748;
            font-weight: 600;
            font-size: 14px;
        }

        label i {
            color: #667eea;
            font-size: 16px;
        }

        input:not([type="file"]), select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: white;
            color: #2d3748;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        select {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23667eea' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 18px;
            padding-right: 40px;
        }

        input[type="file"] {
            padding: 10px;
            border: 2px dashed #e2e8f0;
            border-radius: 10px;
            background: #f7fafc;
            cursor: pointer;
            width: 100%;
            font-size: 13px;
            transition: all 0.3s ease;
        }

        input[type="file"]:hover {
            border-color: #667eea;
            background: #edf2f7;
        }

        .current-photo {
            text-align: center;
            padding: 15px;
            background: #f7fafc;
            border-radius: 10px;
            margin-bottom: 10px;
        }

        .current-photo img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            border: 3px solid white;
        }

        .current-photo small {
            display: block;
            color: #718096;
            margin-top: 8px;
            font-size: 12px;
        }

        .help-text {
            color: #718096;
            font-size: 12px;
            margin-top: 5px;
            display: block;
        }

        .btn {
            padding: 14px 24px;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-submit {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
            width: 100%;
            box-shadow: 0 4px 15px rgba(72, 187, 120, 0.3);
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(72, 187, 120, 0.4);
        }

        .btn-cancel {
            background: #f7fafc;
            color: #4a5568;
            width: 100%;
            margin-top: 12px;
            border: 2px solid #e2e8f0;
        }

        .btn-cancel:hover {
            background: #edf2f7;
            border-color: #cbd5e0;
        }

        .list-section {
            background: rgba(255, 255, 255, 0.95);
            padding: 35px;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .list-section h3 {
            color: #2d3748;
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .list-section h3 i {
            color: #667eea;
            font-size: 24px;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        thead tr {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        th {
            padding: 16px;
            text-align: left;
            color: white;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        th:first-child {
            border-radius: 10px 0 0 0;
        }

        th:last-child {
            border-radius: 0 10px 0 0;
        }

        td {
            padding: 16px;
            border-bottom: 1px solid #e2e8f0;
            color: #2d3748;
            font-size: 14px;
        }

        tbody tr {
            transition: all 0.2s ease;
        }

        tbody tr:hover {
            background: #f7fafc;
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        .img-thumb {
            width: 55px;
            height: 55px;
            object-fit: cover;
            border-radius: 12px;
            border: 3px solid #f7fafc;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .no-photo {
            width: 55px;
            height: 55px;
            border-radius: 12px;
            background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: #a0aec0;
            border: 2px solid #e2e8f0;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-edit {
            background: linear-gradient(135deg, #4299e1 0%, #3182ce 100%);
            color: white;
            padding: 8px 14px;
            font-size: 13px;
            box-shadow: 0 2px 8px rgba(66, 153, 225, 0.3);
        }

        .btn-edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(66, 153, 225, 0.4);
        }

        .btn-delete {
            background: linear-gradient(135deg, #fc8181 0%, #f56565 100%);
            color: white;
            padding: 8px 14px;
            font-size: 13px;
            box-shadow: 0 2px 8px rgba(245, 101, 101, 0.3);
        }

        .btn-delete:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(245, 101, 101, 0.4);
        }

        .empty-state {
            text-align: center;
            padding: 80px 20px;
        }

        .empty-state i {
            font-size: 72px;
            color: #cbd5e0;
            margin-bottom: 20px;
            display: block;
        }

        .empty-state h3 {
            color: #4a5568;
            font-size: 20px;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #a0aec0;
            font-size: 15px;
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
                padding: 20px;
            }

            .page-header h1 {
                font-size: 22px;
            }

            .form-section, .list-section {
                padding: 25px 20px;
            }

            table {
                font-size: 12px;
            }

            th, td {
                padding: 12px 10px;
            }

            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<div class="page-container">
    <div class="page-header">
        <h1>
            <i class="bi bi-paw"></i>
            Gestão de Animais
        </h1>
        <a href="rececionista/menuRece.jsp" class="btn-back">
            <i class="bi bi-arrow-left"></i>
            Voltar ao Menu
        </a>
    </div>

    <% if ("sucesso".equals(msg)) { %>
    <div class="alert success">
        <i class="bi bi-check-circle-fill"></i>
        <span>Operação realizada com êxito!</span>
    </div>
    <% } else if ("criado".equals(msg)) { %>
    <div class="alert success">
        <i class="bi bi-check-circle-fill"></i>
        <span>Novo animal registado com sucesso!</span>
    </div>
    <% } else if ("atualizado".equals(msg)) { %>
    <div class="alert success">
        <i class="bi bi-check-circle-fill"></i>
        <span>Dados do animal atualizados com sucesso!</span>
    </div>
    <% } else if ("eliminado".equals(msg)) { %>
    <div class="alert success">
        <i class="bi bi-check-circle-fill"></i>
        <span>Animal eliminado do sistema.</span>
    </div>
    <% } else if ("erroNIF".equals(msg)) { %>
    <div class="alert error">
        <i class="bi bi-exclamation-triangle-fill"></i>
        <span>O NIF do Tutor não existe. Por favor, registe o cliente primeiro.</span>
    </div>
    <% } else if ("erroRaca".equals(msg)) { %>
    <div class="alert error">
        <i class="bi bi-exclamation-triangle-fill"></i>
        <span>A raça selecionada é inválida.</span>
    </div>
    <% } else if ("erroEliminar".equals(msg)) { %>
    <div class="alert error">
        <i class="bi bi-exclamation-triangle-fill"></i>
        <span>Não é possível eliminar este animal porque tem histórico clínico ou familiar associado.</span>
    </div>
    <% } else if ("erro".equals(msg)) { %>
    <div class="alert error">
        <i class="bi bi-x-circle-fill"></i>
        <span>Ocorreu um erro. Por favor, verifique os dados e tente novamente.</span>
    </div>
    <% } %>

    <div class="container">
        <div class="form-section">
            <h3>
                <% if (edit != null) { %>
                <i class="bi bi-pencil-square"></i>
                Editar Animal
                <% } else { %>
                <i class="bi bi-plus-circle"></i>
                Registar Novo Animal
                <% } %>
            </h3>

            <form action="${pageContext.request.contextPath}/AnimalServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="acao" value="salvar">
                <input type="hidden" name="idPaciente" value="<%= (edit != null) ? edit.getidPaciente() : "0" %>">
                <input type="hidden" name="fotoAtual"
                       value="<%= (edit != null && edit.getFoto() != null) ? edit.getFoto() : "" %>">

                <div class="form-group">
                    <label>
                        <i class="bi bi-tag"></i>
                        Nome do Animal
                    </label>
                    <input type="text" name="nome" value="<%= (edit != null) ? edit.getNome() : "" %>"
                           required placeholder="Ex: Max, Luna, Bobby">
                </div>

                <div class="form-group">
                    <label>
                        <i class="bi bi-cpu"></i>
                        Transponder (Microchip)
                    </label>
                    <input type="text" name="transponder"
                           value="<%= (edit != null && edit.getTransponder() != null) ? edit.getTransponder() : "" %>"
                           pattern="[0-9]{15}" title="O transponder deve ter 15 dígitos"
                           placeholder="Ex: 620098100123456">
                    <span class="help-text">15 dígitos numéricos (opcional)</span>
                </div>

                <div class="form-group">
                    <label>
                        <i class="bi bi-calendar-event"></i>
                        Data de Nascimento
                    </label>
                    <input type="date" name="dataNascimento"
                           value="<%= (edit != null && edit.getDataNascimento() != null) ? edit.getDataNascimento() : "" %>"
                           required>
                </div>

                <div class="form-group">
                    <label>
                        <i class="bi bi-calendar-x"></i>
                        Data de Óbito
                    </label>
                    <input type="date" name="dataObito"
                           value="<%= (edit != null && edit.getDataObito() != null) ? edit.getDataObito() : "" %>">
                    <span class="help-text">Opcional - deixe em branco se o animal está vivo</span>
                </div>

                <div class="form-group">
                    <label>
                        <i class="bi bi-person-badge"></i>
                        NIF do Tutor
                    </label>
                    <input type="text" name="nif" value="<%= (edit != null) ? edit.getNifDono() : "" %>"
                           required pattern="[0-9]{9}" title="Deve ter 9 dígitos" placeholder="123456789">
                </div>

                <div class="form-group">
                    <label>
                        <i class="bi bi-animal"></i>
                        Raça
                    </label>
                    <select name="raca" required>
                        <option value="" disabled <%= (edit == null) ? "selected" : "" %>>Selecione a raça...</option>
                        <optgroup label="Cães">
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
                        <optgroup label="Gatos">
                            <option value="Siamês" <%= (edit != null && "Siamês".equals(edit.getRaca())) ? "selected" : "" %>>
                                Siamês
                            </option>

                            <option value="Maine Coon" <%= (edit != null && "Maine Coon".equals(edit.getRaca())) ? "selected" : "" %>>
                                Maine Coon
                            </option>


                            <option value="Persa" <%= (edit != null && "Persa".equals(edit.getRaca())) ? "selected" : "" %>>
                                Persa
                            </option>
                            <option value="Ragdoll" <%= (edit != null && "Ragdoll".equals(edit.getRaca())) ? "selected" : "" %>>
                                Ragdoll
                            </option>
                            <option value="Sphynx" <%= (edit != null && "Sphynx".equals(edit.getRaca())) ? "selected" : "" %>>
                                Sphynx
                            </option>
                        </optgroup>
                        <optgroup label="Outros">
                            <option value="Papagaio Cinzento" <%= (edit != null && "Papagaio Cinzento".equals(edit.getRaca())) ? "selected" : "" %>>
                                Papagaio Cinzento
                            </option>
                            <option value="Catatua" <%= (edit != null && "Catatua".equals(edit.getRaca())) ? "selected" : "" %>>
                                Catatua
                            </option>
                            <option value="Caturra" <%= (edit != null && "Caturra".equals(edit.getRaca())) ? "selected" : "" %>>
                                Caturra
                            </option>

                            <option value="Peixe Dourado" <%= (edit != null && "Peixe Dourado".equals(edit.getRaca())) ? "selected" : "" %>>
                                Peixe Dourado
                            </option>
                            <option value="Coelho Leão" <%= (edit != null && "Coelho Leão".equals(edit.getRaca())) ? "selected" : "" %>>
                                Coelho Leão
                            </option>
                            <option value="Porquinho-da-índia Inglês" <%= (edit != null && "Porquinho-da-índia Inglês".equals(edit.getRaca())) ? "selected" : "" %>>
                                Porquinho-da-índia Inglês
                            </option>
                        </optgroup>
                    </select>
                </div>

                <div class="form-group">
                    <label>
                        <i class="bi bi-speedometer"></i>
                        Peso (Kg)
                    </label>
                    <input type="number" step="0.1" name="peso"
                           value="<%= (edit != null) ? edit.getPesoAtual() : "" %>"
                           required placeholder="Ex: 12.5">
                </div>

                <div class="form-group">
                    <label>
                        <i class="bi bi-gender-ambiguous"></i>
                        Sexo
                    </label>
                    <select name="sexo">
                        <option value="M" <%= (edit != null && edit.getSexo() == 'M') ? "selected" : "" %>>Macho
                        </option>
                        <option value="F" <%= (edit != null && edit.getSexo() == 'F') ? "selected" : "" %>>Fêmea
                        </option>
                    </select>
                </div>

                <div class="form-group">
                    <label>
                        <i class="bi bi-camera"></i>
                        Fotografia
                    </label>
                    <% if (edit != null && edit.getFoto() != null && !edit.getFoto().isEmpty()) { %>
                    <div class="current-photo">
                        <img src="${pageContext.request.contextPath}/<%= edit.getFoto() %>" alt="Foto atual">
                        <small>Carregue nova foto para substituir</small>
                    </div>
                    <% } %>
                    <input type="file" name="foto" accept="image/*">
                </div>

                <button type="submit" class="btn btn-submit">
                    <i class="bi bi-<%= (edit != null) ? "check-circle" : "plus-circle" %>"></i>
                    <%= (edit != null) ? "Atualizar Dados" : "Registar Animal" %>
                </button>

                <% if (edit != null) { %>
                <a href="${pageContext.request.contextPath}/AnimalServlet?acao=listar" class="btn btn-cancel">
                    <i class="bi bi-x-circle"></i>
                    Cancelar Edição
                </a>
                <% } %>
            </form>
        </div>

        <div class="list-section">
            <h3>
                <i class="bi bi-list-ul"></i>
                Animais Registados
            </h3>
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
                        <div class="no-photo">
                            <i class="bi bi-image"></i>
                        </div>
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
                               class="btn btn-edit">
                                <i class="bi bi-pencil"></i>
                                Editar
                            </a>
                            <a href="${pageContext.request.contextPath}/AnimalServlet?acao=eliminar&id=<%= p.getidPaciente() %>"
                               class="btn btn-delete"
                               onclick="return confirm('Tem a certeza que deseja eliminar <%= p.getNome() %>?');">
                                <i class="bi bi-trash"></i>
                                Eliminar
                            </a>
                        </div>
                    </td>
                </tr>
                <% }
                } else { %>
                <tr>
                    <td colspan="6">
                        <div class="empty-state">
                            <i class="bi bi-inbox"></i>
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
</div>

</body>
</html>