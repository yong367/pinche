package net.shopxx.component;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.*;

/**
 * 任务全局锁
 */
@Component
public class SystemLock {
    public static final String TASK_INFO_LOCK="taskInfo";
    public static final String TASK_NOTIFY_LOCK="taskNotifyLock";
    public static final String TASK_MEMBERMAPPING_LOCK="taskMemberMappingLock";
    private static final Long maxIdle = 3600 * 2 * 1000L;
    private final Map<String, Map<Long, ObjectLock>> lockTypeMap = new HashMap<>();

    @PostConstruct
    private void initLockTypeMap() {
        lockTypeMap.put(TASK_INFO_LOCK,new HashMap<Long, ObjectLock>());
        lockTypeMap.put(TASK_NOTIFY_LOCK,new HashMap<Long, ObjectLock>());
        lockTypeMap.put(TASK_MEMBERMAPPING_LOCK,new HashMap<Long, ObjectLock>());
    }

    private ObjectLock createObjectLock(Long objectId,String lockTypeName) {
        Map<Long, ObjectLock> map = lockTypeMap.get(lockTypeName);
        ObjectLock lock = map.get(objectId);
        if (lock == null) {
            lock = new ObjectLock(objectId);
            map.put(objectId, lock);
        }
        return lock;
    }

    public ObjectLock getAndCreateLock(Long objectId,String lockTypeName) {
        ObjectLock lock;
        Map<Long, ObjectLock> map = lockTypeMap.get(lockTypeName);
        synchronized (map) {
            lock = map.get(objectId);
            if (lock == null) {
                lock = createObjectLock(objectId,lockTypeName);
            }
            lock.use();
        }
        return lock;
    }

    private boolean isExpired(ObjectLock lock) {
        return System.currentTimeMillis() - lock.lastUseTime() >= maxIdle;
    }

    @Scheduled(cron = "0 0/30 * * * ?")//每30分钟检测一次空闲时间超过2小时的lock
    public void processExpires() {
        Iterator<String> it=lockTypeMap.keySet().iterator();
        while (it.hasNext()){
            String keyName = it.next();
            Map<Long, ObjectLock> map = lockTypeMap.get(keyName);
            ObjectLock[] objectLocks;
            synchronized (map) {
                Collection<ObjectLock> values = map.values();
                objectLocks = values.toArray(new ObjectLock[values.size()]);
            }
            for (ObjectLock lock : objectLocks) {
                if (isExpired(lock)) {
                    synchronized (map) {
                        if (isExpired(lock)) {
                            map.remove(lock.getObjectId());
                        }
                    }
                }
            }
        }


    }


    public class ObjectLock {

        private Long objectId;
        private Long lastUsedTime = System.currentTimeMillis();

        ObjectLock(Long objectId) {
            this.objectId = objectId;
        }

        public Long getObjectId() {
            return objectId;
        }

        public void use() {
            lastUsedTime = System.currentTimeMillis();
        }

        Long lastUseTime() {
            return lastUsedTime;
        }

    }
}
