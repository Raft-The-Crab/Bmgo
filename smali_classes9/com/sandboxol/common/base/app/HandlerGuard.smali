.class public Lcom/sandboxol/common/base/app/HandlerGuard;
.super Ljava/lang/Object;
.source "SourceFile"

# instance fields
.field private app:Lcom/sandboxol/common/base/app/BaseApplication;


# direct methods
.method public constructor <init>(Lcom/sandboxol/common/base/app/BaseApplication;)V
    .locals 0

    .line 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 2
    iput-object p1, p0, Lcom/sandboxol/common/base/app/HandlerGuard;->app:Lcom/sandboxol/common/base/app/BaseApplication;

    .line 3
    return-void
.end method

.method public run()V
    .locals 4

    .line 1
    :loop_start
    invoke-static {}, Ljava/lang/Thread;->getDefaultUncaughtExceptionHandler()Ljava/lang/Thread$UncaughtExceptionHandler;
    move-result-object v0

    .line 2
    instance-of v1, v0, Lcom/sandboxol/common/base/app/BaseApplication$1;
    if-nez v1, :skip_set

    .line 3
    # Create a new BaseApplication$1 wrapping the current handler (v0)
    new-instance v1, Lcom/sandboxol/common/base/app/BaseApplication$1;
    iget-object v2, p0, Lcom/sandboxol/common/base/app/HandlerGuard;->app:Lcom/sandboxol/common/base/app/BaseApplication;
    invoke-direct {v1, v2, v0}, Lcom/sandboxol/common/base/app/BaseApplication$1;-><init>(Lcom/sandboxol/common/base/app/BaseApplication;Ljava/lang/Thread$UncaughtExceptionHandler;)V
    invoke-static {v1}, Ljava/lang/Thread;->setDefaultUncaughtExceptionHandler(Ljava/lang/Thread$UncaughtExceptionHandler;)V

    .line 4
    :skip_set
    const-wide/16 v2, 0x2710    # 10000

    .line 5
    :try_start
    invoke-static {v2, v3}, Ljava/lang/Thread;->sleep(J)V
    :try_end
    goto :loop_start

    .catch Ljava/lang/InterruptedException; {:try_start .. :try_end} :catch_interrupted

    .line 6
    :catch_interrupted
    move-exception v0

    .line 7
    return-void
.end method