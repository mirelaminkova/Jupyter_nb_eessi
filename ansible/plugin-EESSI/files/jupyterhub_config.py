from traitlets import Unicode
from jupyterhub.handlers import LogoutHandler
from jhub_remote_user_authenticator.remote_user_auth import RemoteUserLoginHandler, RemoteUserAuthenticator

class MyLogoutHandler(LogoutHandler):
    async def render_logout_page(self):
        logout_endpoint = self.authenticator.logout_endpoint
        self.redirect(logout_endpoint)

class MyAuthenticator(RemoteUserAuthenticator):
    """
    Accept the authenticated user from the header, based on Remote_User.
    """
    logout_endpoint = Unicode(
        default_value='/logout',
        config=True,
        help="URL to log the user out and clean the session"
    )

    def get_handlers(self, app):
        return [
            (r'/login', RemoteUserLoginHandler),
            (r'/logout', MyLogoutHandler),
        ]

c.Spawner.default_url = '/lab?reset'
c.Spawner.notebook_dir = '~'
c.Authenticator.admin_users = {'ubuntu'}
c.JupyterHub.ip = '127.0.0.1'
c.JupyterHub.base_url = '/'

c.JupyterHub.authenticator_class = MyAuthenticator
c.JupyterHub.shutdown_on_logout = True

c.AccessTokenAuthenticator.header_name = "REMOTE_USER"
c.AccessTokenAuthenticator.logout_endpoint = "/logout"
