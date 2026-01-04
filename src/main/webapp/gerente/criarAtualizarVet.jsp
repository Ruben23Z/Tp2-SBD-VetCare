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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestão de Veterinários - Sistema Veterinário</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #28a745;
            --info-color: #17a2b8;
            --warning-color: #ffc107;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .main-container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: white;
            text-decoration: none;
            background: rgba(255, 255, 255, 0.2);
            padding: 10px 20px;
            border-radius: 8px;
            transition: all 0.3s ease;
            margin-bottom: 25px;
            backdrop-filter: blur(10px);
        }

        .back-button:hover {
            background: rgba(255, 255, 255, 0.3);
            color: white;
            transform: translateX(-5px);
        }

        .content-wrapper {
            display: grid;
            grid-template-columns: 400px 1fr;
            gap: 25px;
        }

        .card-custom {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
            overflow: hidden;
        }

        .card-header-custom {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 25px;
        }

        .card-header-custom h3 {
            margin: 0;
            font-size: 1.4rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-body-custom {
            padding: 30px;
        }

        .form-group-custom {
            margin-bottom: 20px;
        }

        .form-label-custom {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
            font-size: 0.9rem;
        }

        .form-label-custom i {
            color: var(--primary-color);
        }

        .form-control-custom,
        .form-select-custom {
            width: 100%;
            padding: 11px 14px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background-color: #f8f9fa;
        }

        .form-control-custom:focus,
        .form-select-custom:focus {
            outline: none;
            border-color: var(--primary-color);
            background-color: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-control-custom:read-only {
            background-color: #e9ecef;
            cursor: not-allowed;
        }

        .required-indicator {
            color: #dc3545;
            margin-left: 2px;
        }

        .section-divider {
            border: 0;
            height: 2px;
            background: linear-gradient(to right, var(--primary-color), transparent);
            margin: 25px 0;
        }

        .section-title {
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-submit {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, var(--success-color) 0%, #20c997 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 10px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
        }

        .btn-cancel {
            width: 100%;
            padding: 10px;
            background: #6c757d;
            color: white;
            text-decoration: none;
            text-align: center;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 10px;
            transition: all 0.3s ease;
        }

        .btn-cancel:hover {
            background: #5a6268;
            color: white;
        }

        .table-container {
            overflow-x: auto;
            border-radius: 10px;
        }

        table {
            width: 100%;
            margin: 0;
        }

        thead {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        }

        th {
            padding: 16px 15px;
            font-weight: 600;
            color: #495057;
            text-transform: uppercase;
            font-size: 0.82rem;
            letter-spacing: 0.5px;
            border: none;
        }

        td {
            padding: 14px 15px;
            color: #495057;
            border-bottom: 1px solid #f1f3f5;
            vertical-align: middle;
        }

        tbody tr {
            transition: all 0.2s ease;
        }

        tbody tr:hover {
            background-color: #f8f9fa;
            transform: scale(1.005);
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        .badge-especialidade {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .badge-geral {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            color: #1976d2;
        }

        .badge-cirurgia {
            background: linear-gradient(135deg, #f3e5f5 0%, #e1bee7 100%);
            color: #7b1fa2;
        }

        .badge-dermatologia {
            background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
            color: #f57c00;
        }

        .btn-edit {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            background: linear-gradient(135deg, var(--info-color) 0%, #138496 100%);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-edit:hover {
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(23, 162, 184, 0.4);
        }

        .empty-state {
            text-align: center;
            padding: 50px 20px;
        }

        .empty-state i {
            font-size: 3.5rem;
            color: #dee2e6;
            margin-bottom: 15px;
        }

        .empty-state h5 {
            color: #6c757d;
            margin-bottom: 8px;
        }

        .empty-state p {
            color: #adb5bd;
            font-size: 0.9rem;
        }

        .info-badge {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: start;
            gap: 10px;
            font-size: 0.85rem;
            color: #1565c0;
        }

        .info-badge i {
            color: #2196f3;
            font-size: 1.1rem;
            margin-top: 2px;
        }

        @media (max-width: 1200px) {
            .content-wrapper {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            body {
                padding: 20px 10px;
            }

            .card-header-custom {
                padding: 20px;
            }

            .card-header-custom h3 {
                font-size: 1.2rem;
            }

            .card-body-custom {
                padding: 20px;
            }

            th, td {
                padding: 10px 8px;
                font-size: 0.85rem;
            }
        }
    </style>
</head>
<body>
<div class="main-container">
    <a href="<%= request.getContextPath() %>/GerenteServlet?action=dashboard" class="back-button">
        <i class="bi bi-arrow-left"></i>
        <span>Voltar ao Dashboard</span>
    </a>

    <div class="content-wrapper">
        <div class="card-custom">
            <div class="card-header-custom">
                <h3>
                    <i class="bi bi-<%= (edit != null) ? "pencil-square" : "person-plus" %>"></i>
                    <%= (edit != null) ? "Editar Veterinário" : "Novo Veterinário" %>
                </h3>
            </div>

            <div class="card-body-custom">
                <% if (edit == null) { %>
                <div class="info-badge">
                    <i class="bi bi-info-circle-fill"></i>
                    <span>Preencha os dados para registar um novo veterinário no sistema.</span>
                </div>
                <% } %>

                <form action="<%= request.getContextPath() %>/GerenteServlet" method="post">
                    <input type="hidden" name="action" value="salvarVet">
                    <input type="hidden" name="idUtilizador"
                           value="<%= (edit != null) ? edit.getiDUtilizador() : "0" %>">

                    <div class="form-group-custom">
                        <label class="form-label-custom">
                            <i class="bi bi-credit-card-2-front"></i>
                            Número de Licença
                            <span class="required-indicator">*</span>
                        </label>
                        <input type="text"
                               name="nLicenca"
                               class="form-control-custom"
                               required
                               value="<%= (edit!=null)?edit.getnLicenca():"" %>"
                            <%= (edit!=null)?"readonly":"" %>
                               placeholder="Ex: OMV12345">
                    </div>

                    <div class="form-group-custom">
                        <label class="form-label-custom">
                            <i class="bi bi-person"></i>
                            Nome Completo
                            <span class="required-indicator">*</span>
                        </label>
                        <input type="text"
                               name="nome"
                               class="form-control-custom"
                               required
                               value="<%= (edit!=null)?edit.getNome():"" %>"
                               placeholder="Nome completo do veterinário">
                    </div>

                    <div class="form-group-custom">
                        <label class="form-label-custom">
                            <i class="bi bi-calendar-event"></i>
                            Idade
                            <span class="required-indicator">*</span>
                        </label>
                        <input type="number"
                               name="idade"
                               class="form-control-custom"
                               required
                               min="22"
                               max="70"
                               value="<%= (edit!=null)?edit.getIdade():"" %>"
                               placeholder="Idade">
                    </div>

                    <div class="form-group-custom">
                        <label class="form-label-custom">
                            <i class="bi bi-award"></i>
                            Especialidade
                            <span class="required-indicator">*</span>
                        </label>
                        <select name="especialidade" class="form-select-custom" required>
                            <option value="Geral" <%= (edit != null && "Geral".equals(edit.getEspecialidade())) ? "selected" : "" %>>
                                Medicina Veterinária Geral
                            </option>
                            <option value="Cirurgia" <%= (edit != null && "Cirurgia".equals(edit.getEspecialidade())) ? "selected" : "" %>>
                                Cirurgia Veterinária
                            </option>
                            <option value="Dermatologia" <%= (edit != null && "Dermatologia".equals(edit.getEspecialidade())) ? "selected" : "" %>>
                                Dermatologia Veterinária
                            </option>
                        </select>
                    </div>

                    <% if (edit == null) { %>
                    <hr class="section-divider">
                    <div class="section-title">
                        <i class="bi bi-shield-lock"></i>
                        <span>Credenciais de Acesso</span>
                    </div>

                    <div class="form-group-custom">
                        <label class="form-label-custom">
                            <i class="bi bi-person-circle"></i>
                            Username
                            <span class="required-indicator">*</span>
                        </label>
                        <input type="text"
                               name="username"
                               class="form-control-custom"
                               required
                               placeholder="Nome de utilizador">
                    </div>

                    <div class="form-group-custom">
                        <label class="form-label-custom">
                            <i class="bi bi-key"></i>
                            Password
                            <span class="required-indicator">*</span>
                        </label>
                        <input type="password"
                               name="password"
                               class="form-control-custom"
                               required
                               placeholder="Palavra-passe">
                    </div>
                    <% } %>

                    <button type="submit" class="btn-submit">
                        <i class="bi bi-check-circle"></i>
                        <span>Guardar Veterinário</span>
                    </button>

                    <% if (edit != null) { %>
                    <a href="<%= request.getContextPath() %>/GerenteServlet?action=listarVets" class="btn-cancel">

                        <i class="bi bi-x-circle"></i>
                        <span>Cancelar Edição</span>
                    </a>
                    <% } %>
                </form>
            </div>
        </div>

        <div class="card-custom">
            <div class="card-header-custom">
                <h3>
                    <i class="bi bi-people"></i>
                    Veterinários Registados
                    <% if (vets != null && !vets.isEmpty()) { %>
                    <span style="font-size: 0.9rem; opacity: 0.9; margin-left: 10px;">
                        (<%= vets.size() %>)
                    </span>
                    <% } %>
                </h3>
            </div>

            <div class="card-body-custom">
                <% if (vets == null || vets.isEmpty()) { %>
                <div class="empty-state">
                    <i class="bi bi-inbox"></i>
                    <h5>Nenhum veterinário registado</h5>
                    <p>Adicione o primeiro veterinário através do formulário.</p>
                </div>
                <% } else { %>
                <div class="table-container">
                    <table class="table table-hover mb-0">
                        <thead>
                        <tr>
                            <th><i class="bi bi-credit-card me-2"></i>Licença</th>
                            <th><i class="bi bi-person me-2"></i>Nome</th>
                            <th><i class="bi bi-award me-2"></i>Especialidade</th>
                            <th style="text-align: center;"><i class="bi bi-gear me-2"></i>Ações</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            // CORREÇÃO: Remoção do if (vets != null) redundante que causava o erro de sintaxe
                            for (Veterinario v : vets) {
                                String badgeClass = "";
                                if ("Geral".equals(v.getEspecialidade())) badgeClass = "badge-geral";
                                else if ("Cirurgia".equals(v.getEspecialidade())) badgeClass = "badge-cirurgia";
                                else if ("Dermatologia".equals(v.getEspecialidade())) badgeClass = "badge-dermatologia";
                        %>
                        <tr>
                            <td><strong><%= v.getnLicenca() %></strong></td>
                            <td><%= v.getNome() %></td>
                            <td>
                                    <span class="badge-especialidade <%= badgeClass %>">
                                        <%= v.getEspecialidade() %>
                                    </span>
                            </td>
                            <td style="text-align: center;">
                                <a href="<%= request.getContextPath() %>/GerenteServlet?action=editarVet&licenca=<%= v.getnLicenca() %>"
                                   class="btn-edit">
                                    <i class="bi bi-pencil"></i>
                                    <span>Editar</span>
                                </a>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>