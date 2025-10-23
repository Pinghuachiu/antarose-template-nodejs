"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const helmet_1 = __importDefault(require("helmet"));
const cors_1 = __importDefault(require("cors"));
const compression_1 = __importDefault(require("compression"));
const logger_1 = require("./middlewares/logger");
const error_handler_1 = require("./middlewares/error-handler");
const health_1 = __importDefault(require("./routes/health"));
const hello_1 = __importDefault(require("./routes/hello"));
const error_example_1 = __importDefault(require("./routes/error-example"));
const app = (0, express_1.default)();
const PORT = process.env.PORT || 4000;
// Security Middlewares
app.use((0, helmet_1.default)());
// CORS Configuration
app.use((0, cors_1.default)({
    origin: 'http://localhost:3000',
    credentials: true,
}));
// Compression Middleware
app.use((0, compression_1.default)());
// Body Parser Middlewares
app.use(express_1.default.json());
app.use(express_1.default.urlencoded({ extended: true }));
// Logger Middleware
app.use(logger_1.logger);
// Routes
app.use('/health', health_1.default);
app.use('/api', hello_1.default);
app.use('/api', error_example_1.default);
// Error Handler (必須在最後)
app.use(error_handler_1.errorHandler);
// Start Server
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
//# sourceMappingURL=index.js.map