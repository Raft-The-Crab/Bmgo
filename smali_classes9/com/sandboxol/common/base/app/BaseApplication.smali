.class public Lcom/sandboxol/common/base/app/BaseApplication;
.super Landroid/app/Application;
.source "SourceFile"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/sandboxol/common/base/app/BaseApplication$ThreadPoolLogListener;
    }
.end annotation


# static fields
.field private static application:Lcom/sandboxol/common/base/app/BaseApplication;

.field private static context:Landroid/content/Context;

.field private static env:Ljava/lang/String;

.field private static threadPool:Lcom/sandboxol/common/threadpoollib/PoolThread;


# instance fields
.field private accessToken:Ljava/lang/String;

.field private backupBaseUrl:Ljava/lang/String;

.field private baseUrl:Ljava/lang/String;

.field private certInfo:Ljava/lang/String;

.field private channelId:Ljava/lang/String;

.field public deviceRegisterTime:J

.field private fixedUrl:Ljava/lang/String;

.field private fixedUrlBackup:Ljava/lang/String;

.field private hasReportMd5:Z

.field private packageNameEn:Ljava/lang/String;

.field private region:Ljava/lang/String;

.field private registerTime:J

.field private rootPath:Ljava/lang/String;

.field private sandboxRongKey:Ljava/lang/String;

.field private tempBackupUrl:Ljava/lang/String;

.field private tempUrl:Ljava/lang/String;

.field private userId:J

.field private versionCode:I

.field private versionName:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 1
    new-instance v0, Lcom/sandboxol/common/base/app/oOo;

    .line 2
    .line 3
    invoke-direct {v0}, Lcom/sandboxol/common/base/app/oOo;-><init>()V

    .line 4
    .line 5
    .line 6
    invoke-static {v0}, Lcom/scwang/smart/refresh/layout/SmartRefreshLayout;->setDefaultRefreshInitializer(Lcom/scwang/smart/refresh/layout/listener/OoO;)V

    .line 7
    .line 8
    .line 9
    new-instance v0, Lcom/sandboxol/common/base/app/ooO;

    .line 10
    .line 11
    invoke-direct {v0}, Lcom/sandboxol/common/base/app/ooO;-><init>()V

    .line 12
    .line 13
    .line 14
    invoke-static {v0}, Lcom/scwang/smart/refresh/layout/SmartRefreshLayout;->setDefaultRefreshHeaderCreator(Lcom/scwang/smart/refresh/layout/listener/Ooo;)V

    .line 15
    .line 16
    .line 17
    new-instance v0, Lcom/sandboxol/common/base/app/Ooo;

    .line 18
    .line 19
    invoke-direct {v0}, Lcom/sandboxol/common/base/app/Ooo;-><init>()V

    .line 20
    .line 21
    .line 22
    invoke-static {v0}, Lcom/scwang/smart/refresh/layout/SmartRefreshLayout;->setDefaultRefreshFooterCreator(Lcom/scwang/smart/refresh/layout/listener/ooO;)V

    .line 23
    .line 24
    .line 25
    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 1
    invoke-direct {p0}, Landroid/app/Application;-><init>()V

    .line 2
    .line 3
    .line 4
    const/4 v0, 0x0

    .line 5
    iput-boolean v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->hasReportMd5:Z

    .line 6
    .line 7
    const-string v0, ""

    .line 8
    .line 9
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->certInfo:Ljava/lang/String;

    .line 10
    .line 11
    const-wide/16 v0, 0x0

    .line 12
    .line 13
    iput-wide v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->registerTime:J

    .line 14
    .line 15
    iput-wide v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->deviceRegisterTime:J

    .line 16
    .line 17
    iput-wide v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->userId:J

    .line 18
    .line 19
    return-void
.end method

.method public static synthetic OoO(Landroid/content/Context;Lcom/scwang/smart/refresh/layout/api/Oo;)Lcom/scwang/smart/refresh/layout/api/OoO;
    .locals 0

    .line 1
    invoke-static {p0, p1}, Lcom/sandboxol/common/base/app/BaseApplication;->lambda$static$1(Landroid/content/Context;Lcom/scwang/smart/refresh/layout/api/Oo;)Lcom/scwang/smart/refresh/layout/api/OoO;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic Ooo(Landroid/content/Context;Lcom/scwang/smart/refresh/layout/api/Oo;)Lcom/scwang/smart/refresh/layout/api/Ooo;
    .locals 0

    .line 1
    invoke-static {p0, p1}, Lcom/sandboxol/common/base/app/BaseApplication;->lambda$static$2(Landroid/content/Context;Lcom/scwang/smart/refresh/layout/api/Oo;)Lcom/scwang/smart/refresh/layout/api/Ooo;

    move-result-object p0

    return-object p0
.end method

.method public static getApp()Lcom/sandboxol/common/base/app/BaseApplication;
    .locals 1

    .line 1
    sget-object v0, Lcom/sandboxol/common/base/app/BaseApplication;->application:Lcom/sandboxol/common/base/app/BaseApplication;

    .line 2
    .line 3
    return-object v0
.end method

.method public static getContext()Landroid/content/Context;
    .locals 1

    .line 1
    sget-object v0, Lcom/sandboxol/common/base/app/BaseApplication;->context:Landroid/content/Context;

    .line 2
    .line 3
    return-object v0
.end method

.method public static getEnv()Ljava/lang/String;
    .locals 2

    .line 1
    new-instance v0, Ljava/lang/StringBuilder;

    .line 2
    .line 3
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 4
    .line 5
    .line 6
    sget-object v1, Lcom/sandboxol/common/base/app/BaseApplication;->env:Ljava/lang/String;

    .line 7
    .line 8
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 9
    .line 10
    .line 11
    const-string v1, ""

    .line 12
    .line 13
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 14
    .line 15
    .line 16
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 17
    .line 18
    .line 19
    move-result-object v0

    .line 20
    return-object v0
.end method

.method public static getThreadPool()Lcom/sandboxol/common/threadpoollib/PoolThread;
    .locals 1

    .line 1
    sget-object v0, Lcom/sandboxol/common/base/app/BaseApplication;->threadPool:Lcom/sandboxol/common/threadpoollib/PoolThread;

    .line 2
    .line 3
    return-object v0
.end method

.method private initThreadPool()V
    .locals 2

    .line 1
    invoke-static {}, Lcom/sandboxol/common/transformers/DataTransformers;->getGlobalExecutor()Ljava/util/concurrent/ExecutorService;

    .line 2
    .line 3
    .line 4
    move-result-object v0

    .line 5
    invoke-static {v0}, Lcom/sandboxol/common/threadpoollib/PoolThread$Builder;->create(Ljava/util/concurrent/ExecutorService;)Lcom/sandboxol/common/threadpoollib/PoolThread$Builder;

    .line 6
    .line 7
    .line 8
    move-result-object v0

    .line 9
    const/16 v1, 0x13

    .line 10
    .line 11
    invoke-virtual {v0, v1}, Lcom/sandboxol/common/threadpoollib/PoolThread$Builder;->setPriority(I)Lcom/sandboxol/common/threadpoollib/PoolThread$Builder;

    .line 12
    .line 13
    .line 14
    move-result-object v0

    .line 15
    new-instance v1, Lcom/sandboxol/common/base/app/BaseApplication$ThreadPoolLogListener;

    .line 16
    .line 17
    invoke-direct {v1, p0}, Lcom/sandboxol/common/base/app/BaseApplication$ThreadPoolLogListener;-><init>(Lcom/sandboxol/common/base/app/BaseApplication;)V

    .line 18
    .line 19
    .line 20
    invoke-virtual {v0, v1}, Lcom/sandboxol/common/threadpoollib/PoolThread$Builder;->setListener(Lcom/sandboxol/common/threadpoollib/callback/ThreadListener;)Lcom/sandboxol/common/threadpoollib/PoolThread$Builder;

    .line 21
    .line 22
    .line 23
    move-result-object v0

    .line 24
    invoke-virtual {v0}, Lcom/sandboxol/common/threadpoollib/PoolThread$Builder;->build()Lcom/sandboxol/common/threadpoollib/PoolThread;

    .line 25
    .line 26
    .line 27
    move-result-object v0

    .line 28
    sput-object v0, Lcom/sandboxol/common/base/app/BaseApplication;->threadPool:Lcom/sandboxol/common/threadpoollib/PoolThread;

    .line 29
    .line 30
    return-void
.end method

.method private static synthetic lambda$static$0(Landroid/content/Context;Lcom/scwang/smart/refresh/layout/api/Oo;)V
    .locals 0

    .line 1
    const/4 p0, 0x1

    .line 2
    invoke-interface {p1, p0}, Lcom/scwang/smart/refresh/layout/api/Oo;->setEnableFooterTranslationContent(Z)Lcom/scwang/smart/refresh/layout/api/Oo;

    .line 3
    .line 4
    .line 5
    const/4 p0, 0x0

    .line 6
    invoke-interface {p1, p0}, Lcom/scwang/smart/refresh/layout/api/Oo;->setEnableNestedScroll(Z)Lcom/scwang/smart/refresh/layout/api/Oo;

    .line 7
    .line 8
    .line 9
    invoke-interface {p1, p0}, Lcom/scwang/smart/refresh/layout/api/Oo;->setEnableOverScrollDrag(Z)Lcom/scwang/smart/refresh/layout/api/Oo;

    .line 10
    .line 11
    .line 12
    invoke-interface {p1, p0}, Lcom/scwang/smart/refresh/layout/api/Oo;->setEnableOverScrollBounce(Z)Lcom/scwang/smart/refresh/layout/api/Oo;

    .line 13
    .line 14
    .line 15
    const/high16 p0, 0x41100000    # 9.0f

    .line 16
    .line 17
    invoke-interface {p1, p0}, Lcom/scwang/smart/refresh/layout/api/Oo;->setHeaderMaxDragRate(F)Lcom/scwang/smart/refresh/layout/api/Oo;

    .line 18
    .line 19
    .line 20
    invoke-interface {p1, p0}, Lcom/scwang/smart/refresh/layout/api/Oo;->setFooterMaxDragRate(F)Lcom/scwang/smart/refresh/layout/api/Oo;

    .line 21
    .line 22
    .line 23
    const/high16 p0, 0x3f000000    # 0.5f

    .line 24
    .line 25
    invoke-interface {p1, p0}, Lcom/scwang/smart/refresh/layout/api/Oo;->setDragRate(F)Lcom/scwang/smart/refresh/layout/api/Oo;

    .line 26
    .line 27
    .line 28
    return-void
.end method

.method private static synthetic lambda$static$1(Landroid/content/Context;Lcom/scwang/smart/refresh/layout/api/Oo;)Lcom/scwang/smart/refresh/layout/api/OoO;
    .locals 0

    .line 1
    new-instance p1, Lcom/sandboxol/common/widget/loading/DotsRefreshHeader;

    .line 2
    .line 3
    invoke-direct {p1, p0}, Lcom/sandboxol/common/widget/loading/DotsRefreshHeader;-><init>(Landroid/content/Context;)V

    .line 4
    .line 5
    .line 6
    return-object p1
.end method

.method private static synthetic lambda$static$2(Landroid/content/Context;Lcom/scwang/smart/refresh/layout/api/Oo;)Lcom/scwang/smart/refresh/layout/api/Ooo;
    .locals 0

    .line 1
    new-instance p1, Lcom/sandboxol/common/widget/loading/DotsRefreshFooter;

    .line 2
    .line 3
    invoke-direct {p1, p0}, Lcom/sandboxol/common/widget/loading/DotsRefreshFooter;-><init>(Landroid/content/Context;)V

    .line 4
    .line 5
    .line 6
    return-object p1
.end method

.method public static synthetic ooO(Landroid/content/Context;Lcom/scwang/smart/refresh/layout/api/Oo;)V
    .locals 0

    .line 1
    invoke-static {p0, p1}, Lcom/sandboxol/common/base/app/BaseApplication;->lambda$static$0(Landroid/content/Context;Lcom/scwang/smart/refresh/layout/api/Oo;)V

    return-void
.end method

.method public static setContext(Landroid/content/Context;)V
    .locals 0
    .annotation build Landroidx/annotation/VisibleForTesting;
    .end annotation

    .line 1
    sput-object p0, Lcom/sandboxol/common/base/app/BaseApplication;->context:Landroid/content/Context;

    .line 2
    .line 3
    return-void
.end method

.method public static setEnv(Ljava/lang/String;)V
    .locals 0

    .line 1
    sput-object p0, Lcom/sandboxol/common/base/app/BaseApplication;->env:Ljava/lang/String;

    .line 2
    .line 3
    return-void
.end method


# virtual methods
.method protected attachBaseContext(Landroid/content/Context;)V
    .locals 0

    .line 1
    sput-object p1, Lcom/sandboxol/common/base/app/BaseApplication;->context:Landroid/content/Context;

    .line 2
    .line 3
    invoke-static {p1}, Lcom/sandboxol/common/utils/CommonHelper;->getAttachBaseContext(Landroid/content/Context;)Landroid/content/Context;

    .line 4
    .line 5
    .line 6
    move-result-object p1

    .line 7
    invoke-super {p0, p1}, Landroid/app/Application;->attachBaseContext(Landroid/content/Context;)V

    .line 8
    .line 9
    .line 10
    return-void
.end method

.method public getAccessToken()Ljava/lang/String;
    .locals 1

    .line 1
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->accessToken:Ljava/lang/String;

    .line 2
    .line 3
    if-nez v0, :cond_0

    .line 4
    .line 5
    const-string v0, "Access-Token"

    .line 6
    .line 7
    invoke-static {p0, v0}, Lcom/sandboxol/common/utils/SharedUtils;->getString(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    .line 8
    .line 9
    .line 10
    move-result-object v0

    .line 11
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->accessToken:Ljava/lang/String;

    .line 12
    .line 13
    :cond_0
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->accessToken:Ljava/lang/String;

    .line 14
    .line 15
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    .line 16
    .line 17
    .line 18
    move-result v0

    .line 19
    if-eqz v0, :cond_1

    .line 20
    .line 21
    const-string v0, ""

    .line 22
    .line 23
    goto :goto_0

    .line 24
    :cond_1
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->accessToken:Ljava/lang/String;

    .line 25
    .line 26
    :goto_0
    return-object v0
.end method

.method public getCertInfo()Ljava/lang/String;
    .locals 1

    .line 1
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->certInfo:Ljava/lang/String;

    .line 2
    .line 3
    return-object v0
.end method

.method public getChannelId()Ljava/lang/String;
    .locals 2

    .line 1
    new-instance v0, Ljava/lang/StringBuilder;

    .line 2
    .line 3
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 4
    .line 5
    .line 6
    iget-object v1, p0, Lcom/sandboxol/common/base/app/BaseApplication;->channelId:Ljava/lang/String;

    .line 7
    .line 8
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 9
    .line 10
    .line 11
    const-string v1, ""

    .line 12
    .line 13
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 14
    .line 15
    .line 16
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 17
    .line 18
    .line 19
    move-result-object v0

    .line 20
    return-object v0
.end method

.method public getCurUserId()J
    .locals 5

    .line 1
    iget-wide v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->userId:J

    .line 2
    .line 3
    const-wide/16 v2, 0x0

    .line 4
    .line 5
    cmp-long v4, v0, v2

    .line 6
    .line 7
    if-nez v4, :cond_0

    .line 8
    .line 9
    const-string/jumbo v0, "userId"

    .line 10
    .line 11
    .line 12
    invoke-static {p0, v0, v2, v3}, Lcom/sandboxol/common/utils/SharedUtils;->getLong(Landroid/content/Context;Ljava/lang/String;J)J

    .line 13
    .line 14
    .line 15
    move-result-wide v0

    .line 16
    iput-wide v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->userId:J

    .line 17
    .line 18
    :cond_0
    iget-wide v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->userId:J

    .line 19
    .line 20
    return-wide v0
.end method

.method public getCurUserRegion()Ljava/lang/String;
    .locals 2

    .line 1
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->region:Ljava/lang/String;

    .line 2
    .line 3
    const-string v1, ""

    .line 4
    .line 5
    if-nez v0, :cond_0

    .line 6
    .line 7
    const-string/jumbo v0, "userRegion"

    .line 8
    .line 9
    .line 10
    invoke-static {p0, v0, v1}, Lcom/sandboxol/common/utils/SharedUtils;->getString(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    .line 11
    .line 12
    .line 13
    move-result-object v0

    .line 14
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->region:Ljava/lang/String;

    .line 15
    .line 16
    :cond_0
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->region:Ljava/lang/String;

    .line 17
    .line 18
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    .line 19
    .line 20
    .line 21
    move-result v0

    .line 22
    if-eqz v0, :cond_1

    .line 23
    .line 24
    goto :goto_0

    .line 25
    :cond_1
    iget-object v1, p0, Lcom/sandboxol/common/base/app/BaseApplication;->region:Ljava/lang/String;

    .line 26
    .line 27
    :goto_0
    return-object v1
.end method

.method public getDeviceRegisterTime()J
    .locals 2

    .line 1
    iget-wide v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->deviceRegisterTime:J

    .line 2
    .line 3
    return-wide v0
.end method

.method public getFixedUrl()Ljava/lang/String;
    .locals 2

    .line 1
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->fixedUrl:Ljava/lang/String;

    .line 2
    .line 3
    if-nez v0, :cond_0

    .line 4
    .line 5
    const-string v0, "fixedUrl"

    .line 6
    .line 7
    const-string v1, ""

    .line 8
    .line 9
    invoke-static {p0, v0, v1}, Lcom/sandboxol/common/utils/SharedUtils;->getString(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    .line 10
    .line 11
    .line 12
    move-result-object v0

    .line 13
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->fixedUrl:Ljava/lang/String;

    .line 14
    .line 15
    :cond_0
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->fixedUrl:Ljava/lang/String;

    .line 16
    .line 17
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    .line 18
    .line 19
    .line 20
    move-result v0

    .line 21
    if-eqz v0, :cond_1

    .line 22
    .line 23
    const-string v0, "https://bmgo-service.onrender.com"

    .line 24
    .line 25
    goto :goto_0

    .line 26
    :cond_1
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->fixedUrl:Ljava/lang/String;

    .line 27
    .line 28
    :goto_0
    return-object v0
.end method

.method public getFixedUrlBackup()Ljava/lang/String;
    .locals 2

    .line 1
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->fixedUrlBackup:Ljava/lang/String;

    .line 2
    .line 3
    if-nez v0, :cond_0

    .line 4
    .line 5
    const-string v0, "fixedUrlBackup"

    .line 6
    .line 7
    const-string v1, ""

    .line 8
    .line 9
    invoke-static {p0, v0, v1}, Lcom/sandboxol/common/utils/SharedUtils;->getString(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    .line 10
    .line 11
    .line 12
    move-result-object v0

    .line 13
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->fixedUrlBackup:Ljava/lang/String;

    .line 14
    .line 15
    :cond_0
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->fixedUrlBackup:Ljava/lang/String;

    .line 16
    .line 17
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    .line 18
    .line 19
    .line 20
    move-result v0

    .line 21
    if-eqz v0, :cond_1

    .line 22
    .line 23
    const-string v0, "https://bmgo-service.onrender.com"

    .line 24
    .line 25
    goto :goto_0

    .line 26
    :cond_1
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->fixedUrlBackup:Ljava/lang/String;

    .line 27
    .line 28
    :goto_0
    return-object v0
.end method

.method public getMetaDataAppVersion()I
    .locals 1

    .line 1
    iget v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->versionCode:I

    .line 2
    .line 3
    return v0
.end method

.method public getMetaDataBackupBaseUrl()Ljava/lang/String;
    .locals 2

    .line 1
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->backupBaseUrl:Ljava/lang/String;

    .line 2
    .line 3
    if-nez v0, :cond_0

    .line 4
    .line 5
    const-string v0, "backupBaseUrl"

    .line 6
    .line 7
    const-string v1, ""

    .line 8
    .line 9
    invoke-static {p0, v0, v1}, Lcom/sandboxol/common/utils/SharedUtils;->getString(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    .line 10
    .line 11
    .line 12
    move-result-object v0

    .line 13
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->backupBaseUrl:Ljava/lang/String;

    .line 14
    .line 15
    :cond_0
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->backupBaseUrl:Ljava/lang/String;

    .line 16
    .line 17
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    .line 18
    .line 19
    .line 20
    move-result v0

    .line 21
    if-eqz v0, :cond_1

    .line 22
    .line 23
    const-string v0, "https://bmgo-service.onrender.com"

    .line 24
    .line 25
    goto :goto_0

    .line 26
    :cond_1
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->backupBaseUrl:Ljava/lang/String;

    .line 27
    .line 28
    :goto_0
    return-object v0
.end method

.method public getMetaDataBaseUrl()Ljava/lang/String;
    .locals 2

    .line 1
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->baseUrl:Ljava/lang/String;

    .line 2
    .line 3
    if-nez v0, :cond_0

    .line 4
    .line 5
    const-string v0, "baseUrl"

    .line 6
    .line 7
    const-string v1, ""

    .line 8
    .line 9
    invoke-static {p0, v0, v1}, Lcom/sandboxol/common/utils/SharedUtils;->getString(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    .line 10
    .line 11
    .line 12
    move-result-object v0

    .line 13
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->baseUrl:Ljava/lang/String;

    .line 14
    .line 15
    :cond_0
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->baseUrl:Ljava/lang/String;

    .line 16
    .line 17
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    .line 18
    .line 19
    .line 20
    move-result v0

    .line 21
    if-eqz v0, :cond_1

    .line 22
    .line 23
    const-string v0, "https://bmgo-service.onrender.com"

    .line 24
    .line 25
    goto :goto_0

    .line 26
    :cond_1
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->baseUrl:Ljava/lang/String;

    .line 27
    .line 28
    :goto_0
    return-object v0
.end method

.method public getMetaDataRootPath()Ljava/lang/String;
    .locals 1

    .line 1
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->rootPath:Ljava/lang/String;

    .line 2
    .line 3
    if-nez v0, :cond_0

    .line 4
    .line 5
    const-string v0, "SandboxOL"

    .line 6
    .line 7
    :cond_0
    return-object v0
.end method

.method public getPackageNameEn()Ljava/lang/String;
    .locals 1

    .line 1
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->packageNameEn:Ljava/lang/String;

    .line 2
    .line 3
    return-object v0
.end method

.method public getRegisterTime()J
    .locals 2

    .line 1
    iget-wide v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->registerTime:J

    .line 2
    .line 3
    return-wide v0
.end method

.method public getSandboxRongKey()Ljava/lang/String;
    .locals 3

    .line 1
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->sandboxRongKey:Ljava/lang/String;

    .line 2
    .line 3
    if-nez v0, :cond_0

    .line 4
    .line 5
    invoke-static {}, Lcom/sandboxol/common/base/app/BaseApplication;->getContext()Landroid/content/Context;

    .line 6
    .line 7
    .line 8
    move-result-object v0

    .line 9
    const-string v1, "sandboxRongKey"

    .line 10
    .line 11
    const-string v2, ""

    .line 12
    .line 13
    invoke-static {v0, v1, v2}, Lcom/sandboxol/common/utils/SharedUtils;->getString(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    .line 14
    .line 15
    .line 16
    move-result-object v0

    .line 17
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->sandboxRongKey:Ljava/lang/String;

    .line 18
    .line 19
    :cond_0
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->sandboxRongKey:Ljava/lang/String;

    .line 20
    .line 21
    return-object v0
.end method

.method public getTempBackupUrl()Ljava/lang/String;
    .locals 2

    .line 1
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->tempBackupUrl:Ljava/lang/String;

    .line 2
    .line 3
    if-nez v0, :cond_0

    .line 4
    .line 5
    const-string v0, "tempBackupUrl"

    .line 6
    .line 7
    const-string v1, ""

    .line 8
    .line 9
    invoke-static {p0, v0, v1}, Lcom/sandboxol/common/utils/SharedUtils;->getString(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    .line 10
    .line 11
    .line 12
    move-result-object v0

    .line 13
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->tempBackupUrl:Ljava/lang/String;

    .line 14
    .line 15
    :cond_0
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->tempBackupUrl:Ljava/lang/String;

    .line 16
    .line 17
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    .line 18
    .line 19
    .line 20
    move-result v0

    .line 21
    if-eqz v0, :cond_1

    .line 22
    .line 23
    const-string v0, "https://bmgo-service.onrender.com"

    .line 24
    .line 25
    goto :goto_0

    .line 26
    :cond_1
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->tempBackupUrl:Ljava/lang/String;

    .line 27
    .line 28
    :goto_0
    return-object v0
.end method

.method public getTempUrl()Ljava/lang/String;
    .locals 2

    .line 1
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->tempUrl:Ljava/lang/String;

    .line 2
    .line 3
    if-nez v0, :cond_0

    .line 4
    .line 5
    const-string v0, "tempUrl"

    .line 6
    .line 7
    const-string v1, ""

    .line 8
    .line 9
    invoke-static {p0, v0, v1}, Lcom/sandboxol/common/utils/SharedUtils;->getString(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    .line 10
    .line 11
    .line 12
    move-result-object v0

    .line 13
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->tempUrl:Ljava/lang/String;

    .line 14
    .line 15
    :cond_0
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->tempUrl:Ljava/lang/String;

    .line 16
    .line 17
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    .line 18
    .line 19
    .line 20
    move-result v0

    .line 21
    if-eqz v0, :cond_1

    .line 22
    .line 23
    const-string v0, "https://bmgo-service.onrender.com"

    .line 24
    .line 25
    goto :goto_0

    .line 26
    :cond_1
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->tempUrl:Ljava/lang/String;

    .line 27
    .line 28
    :goto_0
    return-object v0
.end method

.method public getVersionName()Ljava/lang/String;
    .locals 1

    .line 1
    iget-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->versionName:Ljava/lang/String;

    .line 2
    .line 3
    return-object v0
.end method

.method public isHasReportMd5()Z
    .locals 1

    .line 1
    iget-boolean v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->hasReportMd5:Z

    .line 2
    .line 3
    return v0
.end method

.method public onConfigurationChanged(Landroid/content/res/Configuration;)V
    .locals 0
    .param p1    # Landroid/content/res/Configuration;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation

        .annotation build Lorg/jetbrains/annotations/NotNull;
        .end annotation
    .end param

    .line 1
    invoke-super {p0, p1}, Landroid/app/Application;->onConfigurationChanged(Landroid/content/res/Configuration;)V

    .line 2
    .line 3
    .line 4
    sget-object p1, Lcom/sandboxol/common/base/app/BaseApplication;->context:Landroid/content/Context;

    .line 5
    .line 6
    invoke-static {p1}, Lcom/sandboxol/common/utils/CommonHelper;->isUseAppLanguage(Landroid/content/Context;)V

    .line 7
    .line 8
    .line 9
    return-void
.end method

.method public onCreate()V
    .locals 6

    .line 1
    :try_start
    invoke-super {p0}, Landroid/app/Application;->onCreate()V

    .line 2
    .line 3
    sput-object p0, Lcom/sandboxol/common/base/app/BaseApplication;->context:Landroid/content/Context;

    .line 4
    sput-object p0, Lcom/sandboxol/common/base/app/BaseApplication;->application:Lcom/sandboxol/common/base/app/BaseApplication;

    .line 5
    .line 6
    invoke-direct {p0}, Lcom/sandboxol/common/base/app/BaseApplication;->initThreadPool()V

    .line 7
    .line 8
    sget-object v0, Lcom/sandboxol/common/base/app/BaseApplication;->context:Landroid/content/Context;

    .line 9
    invoke-static {v0}, Lcom/sandboxol/common/utils/CommonHelper;->useAppLanguage(Landroid/content/Context;)V

    .line 10
    .line 11
    # Install global uncaught exception handler to capture crashes
    new-instance v0, Lcom/sandboxol/common/base/app/BaseApplication$1;
    invoke-direct {v0, p0}, Lcom/sandboxol/common/base/app/BaseApplication$1;-><init>(Lcom/sandboxol/common/base/app/BaseApplication;)V
    invoke-static {v0}, Ljava/lang/Thread;->setDefaultUncaughtExceptionHandler(Ljava/lang/Thread$UncaughtExceptionHandler;)V

    .line 12
    :try_end
    goto :end_label

    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :catch

    .line 13
    :catch
    move-exception v1

    .line 14
    const-string v0, "BaseApplication"

    .line 15
    invoke-virtual {v1}, Ljava/lang/Throwable;->toString()Ljava/lang/String;

    .line 16
    move-result-object v2

    .line 17
    invoke-static {v0, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 18
    invoke-virtual {v1}, Ljava/lang/Throwable;->printStackTrace()V

    .line 19
    :end_label
    return-void
.end method

.method public resetBackupBaseUrl()V
    .locals 1

    .line 1
    const/4 v0, 0x0

    .line 2
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->backupBaseUrl:Ljava/lang/String;

    .line 3
    .line 4
    return-void
.end method

.method public resetBaseUrl()V
    .locals 1

    .line 1
    const/4 v0, 0x0

    .line 2
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->baseUrl:Ljava/lang/String;

    .line 3
    .line 4
    return-void
.end method

.method public setAccessToken(Ljava/lang/String;)V
    .locals 1

    .line 1
    const/4 v0, 0x0

    .line 2
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->accessToken:Ljava/lang/String;

    .line 3
    .line 4
    const-string v0, "Access-Token"

    .line 5
    .line 6
    invoke-static {p0, v0, p1}, Lcom/sandboxol/common/utils/SharedUtils;->putString(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 7
    .line 8
    .line 9
    return-void
.end method

.method public setBackupBaseUrl(Ljava/lang/String;)V
    .locals 1

    .line 1
    const/4 v0, 0x0

    .line 2
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->backupBaseUrl:Ljava/lang/String;

    .line 3
    .line 4
    const-string v0, "backupBaseUrl"

    .line 5
    .line 6
    invoke-static {p0, v0, p1}, Lcom/sandboxol/common/utils/SharedUtils;->putString(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 7
    .line 8
    .line 9
    return-void
.end method

.method public setBaseUrl(Ljava/lang/String;)V
    .locals 1

    .line 1
    const/4 v0, 0x0

    .line 2
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->baseUrl:Ljava/lang/String;

    .line 3
    .line 4
    const-string v0, "baseUrl"

    .line 5
    .line 6
    invoke-static {p0, v0, p1}, Lcom/sandboxol/common/utils/SharedUtils;->putString(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 7
    .line 8
    .line 9
    return-void
.end method

.method public setCertInfo(Ljava/lang/String;)V
    .locals 0

    .line 1
    iput-object p1, p0, Lcom/sandboxol/common/base/app/BaseApplication;->certInfo:Ljava/lang/String;

    .line 2
    .line 3
    return-void
.end method

.method public setChannelId(Ljava/lang/String;)V
    .locals 0

    .line 1
    iput-object p1, p0, Lcom/sandboxol/common/base/app/BaseApplication;->channelId:Ljava/lang/String;

    .line 2
    .line 3
    return-void
.end method

.method public setCurUserId(J)V
    .locals 2

    .line 1
    const-wide/16 v0, 0x0

    .line 2
    .line 3
    iput-wide v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->userId:J

    .line 4
    .line 5
    const-string/jumbo v0, "userId"

    .line 6
    .line 7
    .line 8
    invoke-static {p0, v0, p1, p2}, Lcom/sandboxol/common/utils/SharedUtils;->putLong(Landroid/content/Context;Ljava/lang/String;J)V

    .line 9
    .line 10
    .line 11
    return-void
.end method

.method public setCurUserRegion(Ljava/lang/String;)V
    .locals 1

    .line 1
    const/4 v0, 0x0

    .line 2
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->region:Ljava/lang/String;

    .line 3
    .line 4
    const-string/jumbo v0, "userRegion"

    .line 5
    .line 6
    .line 7
    invoke-static {p0, v0, p1}, Lcom/sandboxol/common/utils/SharedUtils;->putString(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 8
    .line 9
    .line 10
    return-void
.end method

.method public setDeviceRegisterTime(J)V
    .locals 0

    .line 1
    iput-wide p1, p0, Lcom/sandboxol/common/base/app/BaseApplication;->deviceRegisterTime:J

    .line 2
    .line 3
    return-void
.end method

.method public setFixedUrl(Ljava/lang/String;)V
    .locals 1

    .line 1
    const/4 v0, 0x0

    .line 2
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->fixedUrl:Ljava/lang/String;

    .line 3
    .line 4
    const-string v0, "fixedUrl"

    .line 5
    .line 6
    invoke-static {p0, v0, p1}, Lcom/sandboxol/common/utils/SharedUtils;->putString(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 7
    .line 8
    .line 9
    return-void
.end method

.method public setFixedUrlBackup(Ljava/lang/String;)V
    .locals 1

    .line 1
    const/4 v0, 0x0

    .line 2
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->fixedUrlBackup:Ljava/lang/String;

    .line 3
    .line 4
    const-string v0, "fixedUrlBackup"

    .line 5
    .line 6
    invoke-static {p0, v0, p1}, Lcom/sandboxol/common/utils/SharedUtils;->putString(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 7
    .line 8
    .line 9
    return-void
.end method

.method public setHasReportMd5(Z)V
    .locals 0

    .line 1
    iput-boolean p1, p0, Lcom/sandboxol/common/base/app/BaseApplication;->hasReportMd5:Z

    .line 2
    .line 3
    return-void
.end method

.method public setPackageNameEn(Ljava/lang/String;)V
    .locals 0

    .line 1
    iput-object p1, p0, Lcom/sandboxol/common/base/app/BaseApplication;->packageNameEn:Ljava/lang/String;

    .line 2
    .line 3
    return-void
.end method

.method public setRegisterTime(J)V
    .locals 0

    .line 1
    iput-wide p1, p0, Lcom/sandboxol/common/base/app/BaseApplication;->registerTime:J

    .line 2
    .line 3
    return-void
.end method

.method public setRootPath(Ljava/lang/String;)V
    .locals 0

    .line 1
    iput-object p1, p0, Lcom/sandboxol/common/base/app/BaseApplication;->rootPath:Ljava/lang/String;

    .line 2
    .line 3
    return-void
.end method

.method public setSandboxRongKey(Ljava/lang/String;)V
    .locals 1

    .line 1
    const/4 v0, 0x0

    .line 2
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->sandboxRongKey:Ljava/lang/String;

    .line 3
    .line 4
    const-string v0, "sandboxRongKey"

    .line 5
    .line 6
    invoke-static {p0, v0, p1}, Lcom/sandboxol/common/utils/SharedUtils;->putString(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 7
    .line 8
    .line 9
    return-void
.end method

.method public setTempBackupUrl(Ljava/lang/String;)V
    .locals 1

    .line 1
    const/4 v0, 0x0

    .line 2
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->tempBackupUrl:Ljava/lang/String;

    .line 3
    .line 4
    const-string v0, "tempBackupUrl"

    .line 5
    .line 6
    invoke-static {p0, v0, p1}, Lcom/sandboxol/common/utils/SharedUtils;->putString(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 7
    .line 8
    .line 9
    return-void
.end method

.method public setTempUrl(Ljava/lang/String;)V
    .locals 1

    .line 1
    const/4 v0, 0x0

    .line 2
    iput-object v0, p0, Lcom/sandboxol/common/base/app/BaseApplication;->tempUrl:Ljava/lang/String;

    .line 3
    .line 4
    const-string v0, "tempUrl"

    .line 5
    .line 6
    invoke-static {p0, v0, p1}, Lcom/sandboxol/common/utils/SharedUtils;->putString(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 7
    .line 8
    .line 9
    return-void
.end method

.method public setVersionCode(I)V
    .locals 0

    .line 1
    iput p1, p0, Lcom/sandboxol/common/base/app/BaseApplication;->versionCode:I

    .line 2
    .line 3
    return-void
.end method

.method public setVersionName(Ljava/lang/String;)V
    .locals 0

    .line 1
    iput-object p1, p0, Lcom/sandboxol/common/base/app/BaseApplication;->versionName:Ljava/lang/String;

    .line 2
    .line 3
    return-void
.end method
