package net.shopxx.service;

/**
 * 日志打印统一入口
 */
public interface LogPrintService {

    /**
     * 打印系统服务日志
     * @param msg
     */
    void printServerLog(String msg);


    /**
     * 打印苏宁服务日志相关
     * @param msg
     */
    void printSuNingServerLog(String msg);

    void printServerLog(String msg,Exception e);

    void pringSuNingServerErrorLog(String msg);


}
