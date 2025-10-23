"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.logger = void 0;
const logger = (req, res, next) => {
    const startTime = Date.now();
    // Log response after request completes
    res.on('finish', () => {
        const duration = Date.now() - startTime;
        const logMessage = `${req.method} ${req.url} ${res.statusCode} - ${duration}ms`;
        console.log(logMessage);
    });
    next();
};
exports.logger = logger;
//# sourceMappingURL=logger.js.map