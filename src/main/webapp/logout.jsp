<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Invalida a sessão atual (apaga os dados do utilizador logado)
    if (session != null) {
        session.invalidate();
    }
    // Redireciona para a página de login
    response.sendRedirect("login.jsp");
%>