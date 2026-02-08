.class public Lcom/sandboxol/common/base/app/NativeCrashUploader;
.super Ljava/lang/Object;
.source "NativeCrashUploader.java"

# interfaces
.implements Ljava/lang/Runnable;

# instance fields
.field private final context:Lcom/sandboxol/common/base/app/BaseApplication;

# direct methods
.method public constructor <init>(Lcom/sandboxol/common/base/app/BaseApplication;)V
    .locals 0

    .line 1
    iput-object p1, p0, Lcom/sandboxol/common/base/app/NativeCrashUploader;->context:Lcom/sandboxol/common/base/app/BaseApplication;

    .line 2
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 3
    return-void
.end method

# virtual methods
.method public run()V
    .locals 12

    .line 1
    :try_start
    iget-object v0, p0, Lcom/sandboxol/common/base/app/NativeCrashUploader;->context:Lcom/sandboxol/common/base/app/BaseApplication;
    invoke-virtual {v0}, Lcom/sandboxol/common/base/app/BaseApplication;->getFilesDir()Ljava/io/File;
    move-result-object v0
    new-instance v1, Ljava/io/File;
    const-string v2, "crash_reports.txt"
    invoke-direct {v1, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->exists()Z
    move-result v0
    if-nez v0, :file_exists
    return-void

    .line 2
: file_exists
    :try_read_start
    new-instance v3, Ljava/io/FileInputStream;
    invoke-direct {v3, v1}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    new-instance v4, Ljava/io/ByteArrayOutputStream;
    invoke-direct {v4}, Ljava/io/ByteArrayOutputStream;-><init>()V

    const/16 v5, 0x400
    new-array v6, v5, [B

    :read_loop
    invoke-virtual {v3, v6}, Ljava/io/FileInputStream;->read([B)I
    move-result v7
    if-lez v7, :after_read
    invoke-virtual {v4, v6, v0, v7}, Ljava/io/ByteArrayOutputStream;->write([BII)V
    goto :read_loop

    :after_read
    invoke-virtual {v3}, Ljava/io/FileInputStream;->close()V
    invoke-virtual {v4}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B
    move-result-object v8
    new-instance v9, Ljava/lang/String;
    invoke-direct {v9, v8}, Ljava/lang/String;-><init>([B)V

    :try_read_end
    .catch Ljava/lang/Throwable; {:try_read_start .. :try_read_end} :read_catch

    .line 3
    const/4 v0, 0x0
    invoke-virtual {v9}, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v10
    invoke-virtual {v10}, Ljava/lang/String;->length()I
    move-result v0
    if-gtz v0, :has_content
    return-void

    .line 4
:has_content
    new-instance v11, Lorg/json/JSONObject;
    invoke-direct {v11}, Lorg/json/JSONObject;-><init>()V

    .line 5
    const-string v0, "stackTrace"
    invoke-virtual {v11, v0, v9}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 6
    iget-object v0, p0, Lcom/sandboxol/common/base/app/NativeCrashUploader;->context:Lcom/sandboxol/common/base/app/BaseApplication;
    invoke-virtual {v0}, Lcom/sandboxol/common/base/app/BaseApplication;->getVersionName()Ljava/lang/String;
    move-result-object v0
    if-eqz v0, :skip_version

:skip_version
    const-string v2, "appVersion"
    invoke-virtual {v11, v2, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 7
    iget-object v0, p0, Lcom/sandboxol/common/base/app/NativeCrashUploader;->context:Lcom/sandboxol/common/base/app/BaseApplication;
    invoke-virtual {v0}, Lcom/sandboxol/common/base/app/BaseApplication;->getCurUserId()J
    move-result-wide v0
    const-wide/16 v2, 0x0
    cmp-long v4, v0, v2
    if-lez v4, :skip_userid
    new-instance v4, Ljava/lang/String;
    invoke-static {v0, v1}, Ljava/lang/Long;->toString(J)Ljava/lang/String;
    move-result-object v5
    const-string v6, "userId"
    invoke-virtual {v11, v6, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

:skip_userid
    .line 8
    new-instance v12, Lorg/json/JSONObject;
    invoke-direct {v12}, Lorg/json/JSONObject;-><init>()V

    .line 9
    # isRooted (use Firebase CommonUtils if available)
    const-string v0, "com/google/firebase/crashlytics/internal/common/CommonUtils"
    :try_root_start
    invoke-static {}, Lcom/google/firebase/crashlytics/internal/common/CommonUtils;->isRooted()Z
    move-result v0
    if-eqz v0, :root_false
    const/4 v0, 0x1
    goto :root_after

:root_false
    const/4 v0, 0x0

:root_after
    const-string v6, "isRooted"
    invoke-virtual {v12, v6, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;
    :try_root_end
    .catch Ljava/lang/Throwable; {:try_root_start .. :try_root_end} :root_catch

    .line 10
    :try_emulator_start
    invoke-static {}, Lcom/google/firebase/crashlytics/internal/common/CommonUtils;->isEmulator()Z
    move-result v0
    if-eqz v0, :emu_false
    const/4 v0, 0x1
    goto :emu_after

:emu_false
    const/4 v0, 0x0

:emu_after
    const-string v6, "isEmulator"
    invoke-virtual {v12, v6, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;
    :try_emulator_end
    .catch Ljava/lang/Throwable; {:try_emulator_start .. :try_emulator_end} :emu_catch

    .line 11
    # signature
    iget-object v0, p0, Lcom/sandboxol/common/base/app/NativeCrashUploader;->context:Lcom/sandboxol/common/base/app/BaseApplication;
    invoke-static {v0}, Lcom/sandboxol/common/utils/CommonHelper;->getSignature(Landroid/content/Context;)Ljava/lang/String;
    move-result-object v0
    if-eqz v0, :skip_sig
    const-string v2, "signature"
    invoke-virtual {v12, v2, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

:skip_sig
    .line 12
    sget-object v0, Landroid/os/Build;->MODEL:Ljava/lang/String;
    const-string v2, "model"
    invoke-virtual {v12, v2, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 13
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I
    const-string v2, "sdkInt"
    invoke-virtual {v12, v2, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 14
    const-string v0, "deviceInfo"
    invoke-virtual {v11, v0, v12}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 15
    const-string v0, "https://bmgo-service.onrender.com/api/internal/crash-report"
    new-instance v1, Lokhttp3/MediaType;
    const-string v2, "application/json; charset=utf-8"
    invoke-static {v2}, Lokhttp3/MediaType;->parse(Ljava/lang/String;)Lokhttp3/MediaType;
    move-result-object v1
    new-instance v2, Lokhttp3/Request$Builder;
    invoke-direct {v2}, Lokhttp3/Request$Builder;-><init>()V
    invoke-virtual {v2, v0}, Lokhttp3/Request$Builder;->url(Ljava/lang/String;)Lokhttp3/Request$Builder;

    invoke-virtual {v11}, Lorg/json/JSONObject;->toString()Ljava/lang/String;
    move-result-object v7
    invoke-static {v1, v7}, Lokhttp3/RequestBody;->create(Lokhttp3/MediaType;Ljava/lang/String;)Lokhttp3/RequestBody;
    move-result-object v3

    invoke-virtual {v2, v3}, Lokhttp3/Request$Builder;->post(Lokhttp3/RequestBody;)Lokhttp3/Request$Builder;
    invoke-virtual {v2}, Lokhttp3/Request$Builder;->build()Lokhttp3/Request;
    move-result-object v2

    new-instance v3, Lokhttp3/OkHttpClient;
    invoke-direct {v3}, Lokhttp3/OkHttpClient;-><init>()V
    invoke-virtual {v3, v2}, Lokhttp3/OkHttpClient;->newCall(Lokhttp3/Request;)Lokhttp3/Call;
    move-result-object v3
    invoke-interface {v3}, Lokhttp3/Call;->execute()Lokhttp3/Response;
    move-result-object v3

    invoke-virtual {v3}, Lokhttp3/Response;->isSuccessful()Z
    move-result v0
    if-eqz v0, :no_delete

    .line 16
    iget-object v7, p0, Lcom/sandboxol/common/base/app/NativeCrashUploader;->context:Lcom/sandboxol/common/base/app/BaseApplication;
    invoke-virtual {v7}, Lcom/sandboxol/common/base/app/BaseApplication;->getFilesDir()Ljava/io/File;
    move-result-object v7
    new-instance v8, Ljava/io/File;
    const-string v9, "crash_reports.txt"
    invoke-direct {v8, v7, v9}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {v8}, Ljava/io/File;->delete()Z
    move-result v0

:no_delete
    return-void

    .catch Ljava/lang/Throwable; {:try_start .. :no_delete} :main_catch

    .line 17
:read_catch
    move-exception v0
    invoke-virtual {v0}, Ljava/lang/Throwable;->printStackTrace()V
    goto :no_delete

    .line 18
:root_catch
    move-exception v0
    invoke-virtual {v0}, Ljava/lang/Throwable;->printStackTrace()V
    goto :emu_after

    .line 19
:emu_catch
    move-exception v0
    invoke-virtual {v0}, Ljava/lang/Throwable;->printStackTrace()V
    goto :after_read

    .line 20
:main_catch
    move-exception v0
    const-string v1, "NativeCrashUploader"
    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    invoke-virtual {v0}, Ljava/lang/Throwable;->printStackTrace()V
    goto :no_delete
.end method