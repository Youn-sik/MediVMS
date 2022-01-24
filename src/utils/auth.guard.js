import { isAuthGuardActive } from '../constants/config'
import { setCurrentUser, getCurrentUser } from '.'
import navData from '../constants/menu'

export default (to, from, next) => {
  if (to.matched.some(record => record.meta.loginRequired)) {
    if (isAuthGuardActive) {
      const user = getCurrentUser();
      const allMenus = navData.admin
      if (user) {
        const roleArrayHierarchic = to.matched.filter(x => x.meta.roles).map(x => x.meta.roles);
        if (roleArrayHierarchic.every(x => x.includes(user.role))) {
          console.log(to)
          // if(to.fullPath){
          // } else
          if(to.fullPath.indexOf('/dashboards') > -1 && user.dashboard) {
            next();
          } else if (to.fullPath.indexOf('/surgeries') > -1 && user.surgery) {
            next();
          } else if (to.fullPath.indexOf('/sergery-reserv') > -1 && user.schedule) {
            next();
          } else if((to.fullPath.indexOf('/data-list') > -1 || to.fullPath.indexOf('/history-list') > -1) && user.browse) {
            next();
          } else if(to.fullPath.indexOf('/admin') > -1 && user.admin) {
            next();
          } else if(to.fullPath.indexOf('/settings') > -1 && user.setting) {
            next();
          } else {
            next('/unauthorized')
          }
        } else {
          next('/unauthorized')
        }
      } else {
        setCurrentUser(null);
        next('/user/login')
      }
    } else {
      next();
    }
  } else {
    next()
  }
}
