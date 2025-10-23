"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const error_handler_1 = require("../middlewares/error-handler");
const router = (0, express_1.Router)();
// 測試通用錯誤（500）
router.get('/error', (req, res, next) => {
    next(new Error('This is a test error'));
});
// 測試 500 Internal Server Error
router.get('/error/500', (req, res, next) => {
    next(new Error('This is a 500 error'));
});
// 測試 400 Bad Request
router.get('/error/400', (req, res, next) => {
    next(new error_handler_1.AppError(400, 'BAD_REQUEST', 'Invalid request parameters'));
});
// 測試 404 Not Found
router.get('/error/404', (req, res, next) => {
    next(new error_handler_1.AppError(404, 'NOT_FOUND', 'Resource not found'));
});
// 測試 401 Unauthorized
router.get('/error/401', (req, res, next) => {
    next(new error_handler_1.AppError(401, 'UNAUTHORIZED', 'Authentication required'));
});
// 測試 403 Forbidden
router.get('/error/403', (req, res, next) => {
    next(new error_handler_1.AppError(403, 'FORBIDDEN', 'Access denied'));
});
exports.default = router;
//# sourceMappingURL=error-example.js.map