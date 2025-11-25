export const isAuthenticated = (request, response, next) => {
  if (request.session && request.session.user) {
    return next();
  }
  return response.status(401).json({ message: "Unauthorized. Silakan login terlebih dahulu" });
};

export const isInstructor = (request, response, next) => {
  if (request.session && request.session.user) {
    if (request.session.user.role === "instructor") {
      return next();
    }
    return response.status(403).json({ message: "Forbidden. Hanya instructor yang dapat mengakses" });
  }
  return response.status(401).json({ message: "Unauthorized. Silakan login terlebih dahulu" });
};

export const isStudent = (request, response, next) => {
  if (request.session && request.session.user) {
    if (request.session.user.role === "student") {
      return next();
    }
    return response.status(403).json({ message: "Forbidden. Hanya student yang dapat mengakses" });
  }
  return response.status(401).json({ message: "Unauthorized. Silakan login terlebih dahulu" });
};

// export const isAuthenticatedUser = (request, response, next) => {
//   if (request.session && request.session.user) {
//     const { role } = request.session.user;
//     if (role === "instructor" || role === "student") {
//       return next();
//     }
//     return response.status(403).json({ message: "Forbidden. Role tidak valid" });
//   }
//   return response.status(401).json({ message: "Unauthorized. Silakan login terlebih dahulu" });
// };
