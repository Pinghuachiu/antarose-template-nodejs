"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppError = void 0;
exports.errorHandler = errorHandler;
class AppError extends Error {
    statusCode;
    code;
    constructor(statusCode, code, message) {
        super(message);
        this.statusCode = statusCode;
        this.code = code;
        this.name = 'AppError';
    }
}
exports.AppError = AppError;
function errorHandler(error, req, res, _next) {
    // 改进日志 - 包含请求上下文
    const isDevelopment = process.env.NODE_ENV === 'development';
    console.error('[Error Handler]', {
        timestamp: new Date().toISOString(),
        method: req.method,
        url: req.url,
        error: error.message,
        stack: isDevelopment ? error.stack : undefined,
    });
    const statusCode = error instanceof AppError ? error.statusCode : 500;
    const errorCode = error instanceof AppError ? error.code : 'INTERNAL_SERVER_ERROR';
    // 改进 Production 消息 - 对于已知错误显示原始消息
    const message = isDevelopment
        ? error.message
        : error instanceof AppError
            ? error.message
            : 'An unexpected error occurred';
    res.status(statusCode).json({
        success: false,
        error: {
            code: errorCode,
            message,
        },
    });
}
//# sourceMappingURL=error-handler.js.map