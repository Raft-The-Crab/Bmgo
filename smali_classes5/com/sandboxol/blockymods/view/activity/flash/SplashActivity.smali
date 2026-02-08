.class public final Lcom/sandboxol/blockymods/view/activity/flash/SplashActivity;
.super Lcom/sandboxol/common/base/rx/BaseRxAppCompatActivity;
.source "SourceFile"


# annotations
.annotation runtime Lkotlin/Metadata;
    d1 = {
        "\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0008\u0002\n\u0002\u0018\u0002\n\u0002\u0008\u0005\u0018\u00002\u00020\u0001B\u0007\u00a2\u0006\u0004\u0008\t\u0010\u0004J\u000f\u0010\u0003\u001a\u00020\u0002H\u0002\u00a2\u0006\u0004\u0008\u0003\u0010\u0004J\u0019\u0010\u0007\u001a\u00020\u00022\u0008\u0010\u0006\u001a\u0004\u0018\u00010\u0005H\u0014\u00a2\u0006\u0004\u0008\u0007\u0010\u0008\u00a8\u0006\n"
    }
    d2 = {
        "Lcom/sandboxol/blockymods/view/activity/flash/SplashActivity;",
        "Lcom/sandboxol/common/base/rx/BaseRxAppCompatActivity;",
        "",
        "w",
        "()V",
        "Landroid/os/Bundle;",
        "savedInstanceState",
        "onCreate",
        "(Landroid/os/Bundle;)V",
        "<init>",
        "app_googleRelease"
    }
    k = 0x1
    mv = {
        0x1,
        0x9,
        0x0
    }
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 1
    invoke-direct {p0}, Lcom/sandboxol/common/base/rx/BaseRxAppCompatActivity;-><init>()V

    .line 2
    .line 3
    .line 4
    return-void
.end method

.method public static synthetic u(Lcom/sandboxol/blockymods/view/activity/flash/SplashActivity;)V
    .locals 0

    .line 1
    invoke-static {p0}, Lcom/sandboxol/blockymods/view/activity/flash/SplashActivity;->y(Lcom/sandboxol/blockymods/view/activity/flash/SplashActivity;)V

    return-void
.end method

.method public static synthetic v()V
    .locals 0

    .line 1
    invoke-static {}, Lcom/sandboxol/blockymods/view/activity/flash/SplashActivity;->x()V

    return-void
.end method

.method private final w()V
    .locals 3

    .line 1
    invoke-virtual {p0}, Landroid/app/Activity;->getIntent()Landroid/content/Intent;

    .line 2
    .line 3
    .line 4
    move-result-object v0

    .line 5
    if-eqz v0, :cond_0

    .line 6
    .line 7
    const-string v0, "notify.flag"

    .line 8
    .line 9
    invoke-virtual {p0}, Landroid/app/Activity;->getIntent()Landroid/content/Intent;

    .line 10
    .line 11
    .line 12
    move-result-object v1

    .line 13
    invoke-virtual {v1, v0}, Landroid/content/Intent;->hasExtra(Ljava/lang/String;)Z

    .line 14
    .line 15
    .line 16
    move-result v0

    .line 17
    if-eqz v0, :cond_0

    .line 18
    .line 19
    new-instance v0, Ljava/util/ArrayList;

    .line 20
    .line 21
    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 22
    .line 23
    .line 24
    const-class v1, Lcom/sandboxol/blockymods/tasks/EventReportTask;

    .line 25
    .line 26
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 27
    .line 28
    .line 29
    new-instance v1, Lcom/sandboxol/center/tasks/RearStartTask;

    .line 30
    .line 31
    new-instance v2, Lcom/sandboxol/blockymods/view/activity/flash/ooO;

    .line 32
    .line 33
    invoke-direct {v2}, Lcom/sandboxol/blockymods/view/activity/flash/ooO;-><init>()V

    .line 34
    .line 35
    .line 36
    invoke-direct {v1, v0, v2}, Lcom/sandboxol/center/tasks/RearStartTask;-><init>(Ljava/util/List;Ljava/lang/Runnable;)V

    .line 37
    .line 38
    .line 39
    invoke-virtual {v1}, Lcom/sandboxol/center/tasks/RearStartTask;->start()V

    .line 40
    .line 41
    .line 42
    :cond_0
    return-void
.end method

.method private static final x()V
    .locals 3

    .line 1
    invoke-static {}, Lcom/sandboxol/common/base/app/BaseApplication;->getContext()Landroid/content/Context;

    .line 2
    .line 3
    .line 4
    move-result-object v0

    .line 5
    const-string v1, "onFirebasePush"

    .line 6
    .line 7
    const-string v2, "background"

    .line 8
    .line 9
    invoke-static {v0, v1, v2}, Lcom/sandboxol/common/interfaces/ReportDataAdapter;->onEvent(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 10
    .line 11
    .line 12
    const/4 v0, 0x0

    .line 13
    new-array v0, v0, [Ljava/lang/Object;

    .line 14
    .line 15
    const-string v1, "FirebasePush background"

    .line 16
    .line 17
    invoke-static {v1, v0}, Lcom/sandboxol/common/utils/SandboxLogUtils;->i(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 18
    .line 19
    .line 20
    return-void
.end method

.method private static final y(Lcom/sandboxol/blockymods/view/activity/flash/SplashActivity;)V
    .locals 1

    .line 1
    const-string v0, "this$0"

    .line 2
    .line 3
    invoke-static {p0, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullParameter(Ljava/lang/Object;Ljava/lang/String;)V

    .line 4
    .line 5
    .line 6
    const-string v0, "enter_splash_activity_success"

    .line 7
    .line 8
    invoke-static {p0, v0}, Lcom/sandboxol/common/interfaces/ReportDataAdapter;->onEvent(Landroid/content/Context;Ljava/lang/String;)V

    .line 9
    .line 10
    .line 11
    invoke-static {p0}, Lcom/sandboxol/blockymods/view/activity/host/HostActivity;->c0(Landroid/content/Context;)V

    .line 12
    .line 13
    .line 14
    invoke-direct {p0}, Lcom/sandboxol/blockymods/view/activity/flash/SplashActivity;->w()V

    .line 15
    .line 16
    .line 17
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    .line 18
    .line 19
    .line 20
    return-void
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 6

    .line 1
    :try_start
    sget-object v0, Lcom/sandboxol/blockymods/oOoO;->oOo:Lcom/sandboxol/blockymods/oOoO$oOo;

    .line 2
    .line 3
    invoke-virtual {v0}, Lcom/sandboxol/blockymods/oOoO$oOo;->ooO()Ljava/lang/String;

    .line 4
    .line 5
    .line 6
    move-result-object v0

    .line 7
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    .line 8
    .line 9
    .line 10
    move-result-wide v1

    .line 11
    new-instance v3, Ljava/lang/StringBuilder;

    .line 12
    .line 13
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    .line 14
    .line 15
    .line 16
    const-string v4, "SplashActivity startTime--->"

    .line 17
    .line 18
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 19
    .line 20
    .line 21
    invoke-virtual {v3, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    .line 22
    .line 23
    .line 24
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 25
    .line 26
    .line 27
    move-result-object v1

    .line 28
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 29
    .line 30
    .line 31
    invoke-super {p0, p1}, Lcom/sandboxol/common/base/rx/BaseRxAppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    .line 32
    .line 33
    .line 34
    new-instance p1, Ljava/util/ArrayList;

    .line 35
    .line 36
    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    .line 37
    .line 38
    .line 39
    const-class v0, Lcom/sandboxol/blockymods/tasks/InitARouterModuleTask;

    .line 40
    .line 41
    invoke-interface {p1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 42
    .line 43
    .line 44
    const-class v0, Lcom/sandboxol/blockymods/tasks/SetupAccountManagerTask;

    .line 45
    .line 46
    invoke-interface {p1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 47
    .line 48
    .line 49
    new-instance v0, Lcom/sandboxol/center/tasks/RearStartTask;

    .line 50
    .line 51
    new-instance v1, Lcom/sandboxol/blockymods/view/activity/flash/oOo;

    .line 52
    .line 53
    invoke-direct {v1, p0}, Lcom/sandboxol/blockymods/view/activity/flash/oOo;-><init>(Lcom/sandboxol/blockymods/view/activity/flash/SplashActivity;)V

    .line 54
    .line 55
    .line 56
    invoke-direct {v0, p1, v1}, Lcom/sandboxol/center/tasks/RearStartTask;-><init>(Ljava/util/List;Ljava/lang/Runnable;)V

    .line 57
    .line 58
    .line 59
    invoke-virtual {v0, p0}, Lcom/sandboxol/center/tasks/RearStartTask;->setProvider(Lcom/trello/rxlifecycle/ooO;)Lcom/sandboxol/center/tasks/RearStartTask;

    .line 60
    .line 61
    .line 62
    move-result-object p1

    .line 63
    # Skipped starting background init tasks to avoid early crash during debugging
    const/4 v0, 0x0

    .line 64
    .line 65
    .line 66
    :try_end
    goto :end_label

    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :catch

    :catch
    move-exception v5

    .line 67
    const-string v0, "SplashActivity"

    .line 68
    invoke-virtual {v5}, Ljava/lang/Throwable;->toString()Ljava/lang/String;

    .line 69
    move-result-object v1

    .line 70
    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 71
    invoke-virtual {v5}, Ljava/lang/Throwable;->printStackTrace()V

    .line 72
    :end_label
    return-void
.end method
