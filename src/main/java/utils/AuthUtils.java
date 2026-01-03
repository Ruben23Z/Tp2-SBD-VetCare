package utils;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebFilter({"/gerente/*", "/veterinario/*", "/rececionista/*", "/tutor/*"})
public class AuthUtils implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String uri = req.getRequestURI();
        HttpSession session = req.getSession(false);

        //Recursos públicos (não precisam login)
        if (uri.endsWith("login.jsp") || uri.endsWith("login") || uri.endsWith("index.jsp") || uri.contains("/imagens/") || uri.contains("/css/") || uri.contains("/js/")) {

            chain.doFilter(request, response);
            return;
        }

        //Sem sessão -> login
        if (session == null || session.getAttribute("cargo") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String cargo = (String) session.getAttribute("cargo");

        //Controlo por pasta
        if (uri.contains("/gerente/") && !cargo.equals("Gerente")) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (uri.contains("/rececionista/") && !cargo.equals("Rececionista")) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (uri.contains("/veterinario/") && !cargo.equals("Veterinario")) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (uri.contains("/tutor/") && !cargo.equals("Cliente")) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        chain.doFilter(request, response);
    }
}