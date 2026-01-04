<%@ page import="model.Utilizador.Cliente" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
    Cliente edit = (Cliente) request.getAttribute("clienteEditar");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Gestão de Tutores e Animais</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px 20px; font-family: 'Segoe UI', sans-serif; min-height: 100vh; }
        .card-custom { border: none; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); margin-bottom: 20px; background: rgba(255, 255, 255, 0.95); }
        .card-header-custom { background: #fff; border-bottom: 2px solid #f0f0f0; padding: 20px; border-radius: 12px 12px 0 0 !important; }
        .card-header-custom h5 { color: #667eea; font-weight: bold; margin: 0; }
        .btn-purple { background-color: #6f42c1; color: white; border: none; }
        .btn-purple:hover { background-color: #59359a; color: white; }
        .table thead { background-color: #f8f9fa; }
    </style>
</head>
<body>
<div class="container" style="max-width: 1400px;">
    <a href="GerenteServlet?action=dashboard" class="btn btn-light mb-4 shadow-sm">
        <i class="bi bi-arrow-left"></i> Voltar ao Dashboard
    </a>

    <% if(msg != null) { %>
    <div class="alert alert-info alert-dismissible fade show shadow-sm" role="alert">
        <%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <div class="row">
        <div class="col-lg-4">
            <div class="card card-custom">
                <div class="card-header card-header-custom">
                    <h5><i class="bi bi-person-plus-fill"></i> <%= (edit != null) ? "Editar Tutor" : "Novo Tutor" %></h5>
                </div>
                <div class="card-body p-4">
                    <form action="GerenteServlet" method="post">
                        <input type="hidden" name="action" value="salvarTutor">
                        <input type="hidden" name="idUtilizador" value="<%= (edit!=null)?edit.getiDUtilizador():"0" %>">

                        <h6 class="text-uppercase text-muted small fw-bold mb-3">Dados Pessoais</h6>
                        <div class="mb-3">
                            <label class="form-label">Nome Completo</label>
                            <input type="text" name="nome" class="form-control" required value="<%= (edit!=null)?edit.getNome():"" %>">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">NIF</label>
                            <input type="text" name="nif" class="form-control" required pattern="[0-9]{9}"
                                   value="<%= (edit!=null)?edit.getNIF():"" %>" <%= (edit!=null)?"readonly":"" %>>
                        </div>
                        <div class="row g-2 mb-3">
                            <div class="col">
                                <label class="form-label">Email</label>
                                <input type="email" name="email" class="form-control" required value="<%= (edit!=null)?edit.getEmail():"" %>">
                            </div>
                            <div class="col">
                                <label class="form-label">Telefone</label>
                                <input type="text" name="telefone" class="form-control" required value="<%= (edit!=null)?edit.getTelefone():"" %>">
                            </div>
                        </div>

                        <h6 class="text-uppercase text-muted small fw-bold mb-3 mt-4">Morada</h6>
                        <div class="mb-2"><input type="text" name="rua" placeholder="Rua" class="form-control" required value="<%= (edit!=null)?edit.getRua():"" %>"></div>
                        <div class="row g-2 mb-2">
                            <div class="col"><input type="text" name="freguesia" placeholder="Freguesia" class="form-control" value="<%= (edit!=null)?edit.getFreguesia():"" %>"></div>
                            <div class="col"><input type="text" name="concelho" placeholder="Concelho" class="form-control" value="<%= (edit!=null)?edit.getConcelho():"" %>"></div>
                        </div>
                        <div class="row g-2 mb-3">
                            <div class="col"><input type="text" name="distrito" placeholder="Distrito" class="form-control" value="<%= (edit!=null)?edit.getDistrito():"" %>"></div>
                            <div class="col"><input type="text" name="pais" placeholder="País" class="form-control" required value="<%= (edit!=null)?(edit.getPais()!=null?edit.getPais():"Portugal"):"Portugal" %>"></div>
                        </div>

                        <% if (edit == null) { %>
                        <h6 class="text-uppercase text-muted small fw-bold mb-3 mt-4">Acesso</h6>
                        <div class="mb-2"><input type="text" name="username" placeholder="Username" class="form-control" required></div>
                        <div class="mb-3"><input type="password" name="password" placeholder="Password" class="form-control" required></div>
                        <% } %>

                        <div class="d-grid gap-2 mt-4">
                            <button type="submit" class="btn btn-success fw-bold py-2"><i class="bi bi-save"></i> Guardar Tutor</button>
                            <% if(edit != null) { %>
                            <a href="GerenteServlet?action=gerirTutores" class="btn btn-outline-secondary">Cancelar</a>
                            <% } %>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="card card-custom">
                <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                    <h5><i class="bi bi-people-fill"></i> Tutores Registados</h5>
                    <span class="badge bg-primary rounded-pill"><%= (clientes != null) ? clientes.size() : 0 %></span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0 align-middle">
                            <thead class="table-light">
                            <tr>
                                <th class="ps-4">Nome</th>
                                <th>NIF</th>
                                <th>Contacto</th>
                                <th class="text-end pe-4">Ações</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% if(clientes != null && !clientes.isEmpty()) {
                                for(Cliente c : clientes) { %>
                            <tr>
                                <td class="ps-4 fw-bold text-dark"><%= c.getNome() %></td>
                                <td><span class="badge bg-light text-dark border"><%= c.getNIF() %></span></td>
                                <td><small class="text-muted"><i class="bi bi-envelope"></i> <%= c.getEmail() %><br><i class="bi bi-phone"></i> <%= c.getTelefone() %></small></td>
                                <td class="text-end pe-4">
                                    <div class="btn-group">
                                        <a href="GerenteServlet?action=editarTutor&nif=<%= c.getNIF() %>" class="btn btn-sm btn-outline-primary" title="Editar Tutor">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/AnimalServlet?acao=listar&filtroNIF=<%= c.getNIF() %>&origem=gerente" class="btn btn-sm btn-purple" title="Gerir Animais do Tutor">
                                            <i class="bi bi-paw"></i> Animais
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            <%  }
                            } else { %>
                            <tr><td colspan="4" class="text-center py-5 text-muted"><i class="bi bi-inbox fs-1 d-block mb-2"></i>Nenhum tutor encontrado.</td></tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>