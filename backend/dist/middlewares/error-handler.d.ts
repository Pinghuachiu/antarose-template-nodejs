import { Request, Response, NextFunction } from 'express';
export declare class AppError extends Error {
    statusCode: number;
    code: string;
    constructor(statusCode: number, code: string, message: string);
}
export declare function errorHandler(error: Error | AppError, req: Request, res: Response, _next: NextFunction): void;
//# sourceMappingURL=error-handler.d.ts.map