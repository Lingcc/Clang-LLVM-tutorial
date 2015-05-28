; ModuleID = 'minmax_intrn.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct.timeval = type { i64, i64 }
%struct.timezone = type { i32, i32 }
%struct.__mm_store_ss_struct = type { float }

@stderr = external global %struct._IO_FILE*, align 8
@.str = private unnamed_addr constant [12 x i8] c"Usage: %s n\00", align 1
@.str.1 = private unnamed_addr constant [44 x i8] c"Initialize a random buffer of %u floats...\0A\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"Done!\0A\00", align 1
@.str.3 = private unnamed_addr constant [107 x i8] c"%s: in %0.5f ms. Input (#/size/BW): %lu/%0.5f MB/%0.5f MB/s | Output (#/size/BW): %lu/%0.5f MB/%0.5f MB/s\0A\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"org\00", align 1
@.str.5 = private unnamed_addr constant [23 x i8] c"Min (idx): %0.4f (%u)\0A\00", align 1
@.str.6 = private unnamed_addr constant [23 x i8] c"Max (idx): %0.4f (%u)\0A\00", align 1
@.str.7 = private unnamed_addr constant [4 x i8] c"sse\00", align 1
@.str.8 = private unnamed_addr constant [5 x i8] c"sse2\00", align 1

; Function Attrs: nounwind uwtable
define double @get_current_timestamp() #0 {
entry:
  %curt = alloca %struct.timeval, align 8
  %call = call i32 @gettimeofday(%struct.timeval* %curt, %struct.timezone* null) #5
  %tv_sec = getelementptr inbounds %struct.timeval, %struct.timeval* %curt, i32 0, i32 0
  %0 = load i64, i64* %tv_sec, align 8
  %conv = sitofp i64 %0 to double
  %tv_usec = getelementptr inbounds %struct.timeval, %struct.timeval* %curt, i32 0, i32 1
  %1 = load i64, i64* %tv_usec, align 8
  %conv1 = sitofp i64 %1 to double
  %div = fdiv double %conv1, 1.000000e+06
  %add = fadd double %conv, %div
  ret double %add
}

; Function Attrs: nounwind
declare i32 @gettimeofday(%struct.timeval*, %struct.timezone*) #1

; Function Attrs: nounwind uwtable
define void @minmax(i32 %n, float* %buf, i32* %idx_min_, i32* %idx_max_, float* %min_, float* %max_) #0 {
entry:
  %n.addr = alloca i32, align 4
  %buf.addr = alloca float*, align 8
  %idx_min_.addr = alloca i32*, align 8
  %idx_max_.addr = alloca i32*, align 8
  %min_.addr = alloca float*, align 8
  %max_.addr = alloca float*, align 8
  %idx_min = alloca i64, align 8
  %idx_max = alloca i64, align 8
  %min = alloca float, align 4
  %max = alloca float, align 4
  %i = alloca i32, align 4
  %v = alloca float, align 4
  store i32 %n, i32* %n.addr, align 4
  store float* %buf, float** %buf.addr, align 8
  store i32* %idx_min_, i32** %idx_min_.addr, align 8
  store i32* %idx_max_, i32** %idx_max_.addr, align 8
  store float* %min_, float** %min_.addr, align 8
  store float* %max_, float** %max_.addr, align 8
  store i64 0, i64* %idx_min, align 8
  store i64 0, i64* %idx_max, align 8
  store float 0x47EFFFFFE0000000, float* %min, align 4
  store float 0x3810000000000000, float* %max, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4
  %1 = load i32, i32* %n.addr, align 4
  %cmp = icmp ult i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load i32, i32* %i, align 4
  %idxprom = zext i32 %2 to i64
  %3 = load float*, float** %buf.addr, align 8
  %arrayidx = getelementptr inbounds float, float* %3, i64 %idxprom
  %4 = load float, float* %arrayidx, align 4
  store float %4, float* %v, align 4
  %5 = load float, float* %v, align 4
  %6 = load float, float* %min, align 4
  %cmp1 = fcmp olt float %5, %6
  br i1 %cmp1, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  %7 = load float, float* %v, align 4
  store float %7, float* %min, align 4
  %8 = load i32, i32* %i, align 4
  %conv = zext i32 %8 to i64
  store i64 %conv, i64* %idx_min, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  %9 = load float, float* %v, align 4
  %10 = load float, float* %max, align 4
  %cmp2 = fcmp ogt float %9, %10
  br i1 %cmp2, label %if.then.4, label %if.end.6

if.then.4:                                        ; preds = %if.end
  %11 = load float, float* %v, align 4
  store float %11, float* %max, align 4
  %12 = load i32, i32* %i, align 4
  %conv5 = zext i32 %12 to i64
  store i64 %conv5, i64* %idx_max, align 8
  br label %if.end.6

if.end.6:                                         ; preds = %if.then.4, %if.end
  br label %for.inc

for.inc:                                          ; preds = %if.end.6
  %13 = load i32, i32* %i, align 4
  %inc = add i32 %13, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %14 = load i64, i64* %idx_min, align 8
  %conv7 = trunc i64 %14 to i32
  %15 = load i32*, i32** %idx_min_.addr, align 8
  store i32 %conv7, i32* %15, align 4
  %16 = load float, float* %min, align 4
  %17 = load float*, float** %min_.addr, align 8
  store float %16, float* %17, align 4
  %18 = load i64, i64* %idx_max, align 8
  %conv8 = trunc i64 %18 to i32
  %19 = load i32*, i32** %idx_max_.addr, align 8
  store i32 %conv8, i32* %19, align 4
  %20 = load float, float* %max, align 4
  %21 = load float*, float** %max_.addr, align 8
  store float %20, float* %21, align 4
  ret void
}

; Function Attrs: nounwind uwtable
define void @minmax_vec(i32 %n, float* %buf, i32* %idx_min_, i32* %idx_max_, float* %min_, float* %max_) #0 {
entry:
  %.compoundliteral.i.109 = alloca <2 x i64>, align 16
  %__w.addr.i.103 = alloca float, align 4
  %.compoundliteral.i.104 = alloca <4 x float>, align 16
  %__w.addr.i = alloca float, align 4
  %.compoundliteral.i.98 = alloca <4 x float>, align 16
  %i3.addr.i = alloca i32, align 4
  %i2.addr.i = alloca i32, align 4
  %i1.addr.i = alloca i32, align 4
  %i0.addr.i = alloca i32, align 4
  %.compoundliteral.i.93 = alloca <4 x i32>, align 16
  %__i.addr.i = alloca i32, align 4
  %.compoundliteral.i.92 = alloca <4 x i32>, align 16
  %__p.addr.i.91 = alloca float*, align 8
  %__a.addr.i.88 = alloca <4 x float>, align 16
  %__b.addr.i.89 = alloca <4 x float>, align 16
  %__a.addr.i.86 = alloca <4 x float>, align 16
  %__b.addr.i.87 = alloca <4 x float>, align 16
  %__V1.addr.i.83 = alloca <4 x float>, align 16
  %__V2.addr.i.84 = alloca <4 x float>, align 16
  %__M.addr.i.85 = alloca <4 x float>, align 16
  %__V1.addr.i.80 = alloca <4 x float>, align 16
  %__V2.addr.i.81 = alloca <4 x float>, align 16
  %__M.addr.i.82 = alloca <4 x float>, align 16
  %__V1.addr.i.77 = alloca <4 x float>, align 16
  %__V2.addr.i.78 = alloca <4 x float>, align 16
  %__M.addr.i.79 = alloca <4 x float>, align 16
  %__V1.addr.i = alloca <4 x float>, align 16
  %__V2.addr.i = alloca <4 x float>, align 16
  %__M.addr.i = alloca <4 x float>, align 16
  %__a.addr.i.76 = alloca <2 x i64>, align 16
  %__b.addr.i = alloca <2 x i64>, align 16
  %__p.addr.i.74 = alloca float*, align 8
  %__a.addr.i.75 = alloca <4 x float>, align 16
  %__p.addr.i = alloca float*, align 8
  %__a.addr.i = alloca <4 x float>, align 16
  %.compoundliteral.i = alloca <2 x i64>, align 16
  %n.addr = alloca i32, align 4
  %buf.addr = alloca float*, align 8
  %idx_min_.addr = alloca i32*, align 8
  %idx_max_.addr = alloca i32*, align 8
  %min_.addr = alloca float*, align 8
  %max_.addr = alloca float*, align 8
  %sse_idx_min = alloca <2 x i64>, align 16
  %sse_idx_max = alloca <2 x i64>, align 16
  %sse_min = alloca <4 x float>, align 16
  %sse_max = alloca <4 x float>, align 16
  %n_sse = alloca i32, align 4
  %sse_idx = alloca <2 x i64>, align 16
  %sse_4 = alloca <2 x i64>, align 16
  %i = alloca i32, align 4
  %sse_v = alloca <4 x float>, align 16
  %sse_cmp_min = alloca <4 x float>, align 16
  %sse_cmp_max = alloca <4 x float>, align 16
  %mins = alloca [4 x float], align 16
  %maxs = alloca [4 x float], align 16
  %min = alloca float, align 4
  %max = alloca float, align 4
  %idx_min = alloca i32, align 4
  %__a = alloca <4 x i32>, align 16
  %tmp = alloca i32, align 4
  %idx_max = alloca i32, align 4
  %__a21 = alloca <4 x i32>, align 16
  %tmp22 = alloca i32, align 4
  %i25 = alloca i32, align 4
  %v = alloca float, align 4
  %__a36 = alloca <4 x i32>, align 16
  %tmp37 = alloca i32, align 4
  %__a46 = alloca <4 x i32>, align 16
  %tmp47 = alloca i32, align 4
  %i54 = alloca i32, align 4
  %v60 = alloca float, align 4
  store i32 %n, i32* %n.addr, align 4
  store float* %buf, float** %buf.addr, align 8
  store i32* %idx_min_, i32** %idx_min_.addr, align 8
  store i32* %idx_max_, i32** %idx_max_.addr, align 8
  store float* %min_, float** %min_.addr, align 8
  store float* %max_, float** %max_.addr, align 8
  store <2 x i64> zeroinitializer, <2 x i64>* %.compoundliteral.i
  %0 = load <2 x i64>, <2 x i64>* %.compoundliteral.i
  store <2 x i64> %0, <2 x i64>* %sse_idx_min, align 16
  store <2 x i64> zeroinitializer, <2 x i64>* %.compoundliteral.i.109
  %1 = load <2 x i64>, <2 x i64>* %.compoundliteral.i.109
  store <2 x i64> %1, <2 x i64>* %sse_idx_max, align 16
  store float 0x47EFFFFFE0000000, float* %__w.addr.i.103, align 4
  %2 = load float, float* %__w.addr.i.103, align 4
  %vecinit.i.105 = insertelement <4 x float> undef, float %2, i32 0
  %3 = load float, float* %__w.addr.i.103, align 4
  %vecinit1.i.106 = insertelement <4 x float> %vecinit.i.105, float %3, i32 1
  %4 = load float, float* %__w.addr.i.103, align 4
  %vecinit2.i.107 = insertelement <4 x float> %vecinit1.i.106, float %4, i32 2
  %5 = load float, float* %__w.addr.i.103, align 4
  %vecinit3.i.108 = insertelement <4 x float> %vecinit2.i.107, float %5, i32 3
  store <4 x float> %vecinit3.i.108, <4 x float>* %.compoundliteral.i.104
  %6 = load <4 x float>, <4 x float>* %.compoundliteral.i.104
  store <4 x float> %6, <4 x float>* %sse_min, align 16
  store float 0x3810000000000000, float* %__w.addr.i, align 4
  %7 = load float, float* %__w.addr.i, align 4
  %vecinit.i.99 = insertelement <4 x float> undef, float %7, i32 0
  %8 = load float, float* %__w.addr.i, align 4
  %vecinit1.i.100 = insertelement <4 x float> %vecinit.i.99, float %8, i32 1
  %9 = load float, float* %__w.addr.i, align 4
  %vecinit2.i.101 = insertelement <4 x float> %vecinit1.i.100, float %9, i32 2
  %10 = load float, float* %__w.addr.i, align 4
  %vecinit3.i.102 = insertelement <4 x float> %vecinit2.i.101, float %10, i32 3
  store <4 x float> %vecinit3.i.102, <4 x float>* %.compoundliteral.i.98
  %11 = load <4 x float>, <4 x float>* %.compoundliteral.i.98
  store <4 x float> %11, <4 x float>* %sse_max, align 16
  %12 = load i32, i32* %n.addr, align 4
  %conv = zext i32 %12 to i64
  %and = and i64 %conv, -4
  %conv4 = trunc i64 %and to i32
  store i32 %conv4, i32* %n_sse, align 4
  store i32 3, i32* %i3.addr.i, align 4
  store i32 2, i32* %i2.addr.i, align 4
  store i32 1, i32* %i1.addr.i, align 4
  store i32 0, i32* %i0.addr.i, align 4
  %13 = load i32, i32* %i0.addr.i, align 4
  %vecinit.i.94 = insertelement <4 x i32> undef, i32 %13, i32 0
  %14 = load i32, i32* %i1.addr.i, align 4
  %vecinit1.i.95 = insertelement <4 x i32> %vecinit.i.94, i32 %14, i32 1
  %15 = load i32, i32* %i2.addr.i, align 4
  %vecinit2.i.96 = insertelement <4 x i32> %vecinit1.i.95, i32 %15, i32 2
  %16 = load i32, i32* %i3.addr.i, align 4
  %vecinit3.i.97 = insertelement <4 x i32> %vecinit2.i.96, i32 %16, i32 3
  store <4 x i32> %vecinit3.i.97, <4 x i32>* %.compoundliteral.i.93
  %17 = load <4 x i32>, <4 x i32>* %.compoundliteral.i.93
  %18 = bitcast <4 x i32> %17 to <2 x i64>
  store <2 x i64> %18, <2 x i64>* %sse_idx, align 16
  store i32 4, i32* %__i.addr.i, align 4
  %19 = load i32, i32* %__i.addr.i, align 4
  %vecinit.i = insertelement <4 x i32> undef, i32 %19, i32 0
  %20 = load i32, i32* %__i.addr.i, align 4
  %vecinit1.i = insertelement <4 x i32> %vecinit.i, i32 %20, i32 1
  %21 = load i32, i32* %__i.addr.i, align 4
  %vecinit2.i = insertelement <4 x i32> %vecinit1.i, i32 %21, i32 2
  %22 = load i32, i32* %__i.addr.i, align 4
  %vecinit3.i = insertelement <4 x i32> %vecinit2.i, i32 %22, i32 3
  store <4 x i32> %vecinit3.i, <4 x i32>* %.compoundliteral.i.92
  %23 = load <4 x i32>, <4 x i32>* %.compoundliteral.i.92
  %24 = bitcast <4 x i32> %23 to <2 x i64>
  store <2 x i64> %24, <2 x i64>* %sse_4, align 16
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %25 = load i32, i32* %i, align 4
  %26 = load i32, i32* %n_sse, align 4
  %cmp = icmp ult i32 %25, %26
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %27 = load i32, i32* %i, align 4
  %idxprom = zext i32 %27 to i64
  %28 = load float*, float** %buf.addr, align 8
  %arrayidx = getelementptr inbounds float, float* %28, i64 %idxprom
  store float* %arrayidx, float** %__p.addr.i.91, align 8
  %29 = load float*, float** %__p.addr.i.91, align 8
  %30 = bitcast float* %29 to <4 x float>*
  %31 = load <4 x float>, <4 x float>* %30, align 16
  store <4 x float> %31, <4 x float>* %sse_v, align 16
  %32 = load <4 x float>, <4 x float>* %sse_v, align 16
  %33 = load <4 x float>, <4 x float>* %sse_min, align 16
  store <4 x float> %32, <4 x float>* %__a.addr.i.88, align 16
  store <4 x float> %33, <4 x float>* %__b.addr.i.89, align 16
  %34 = load <4 x float>, <4 x float>* %__a.addr.i.88, align 16
  %35 = load <4 x float>, <4 x float>* %__b.addr.i.89, align 16
  %cmpps.i.90 = call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %34, <4 x float> %35, i8 1) #5
  store <4 x float> %cmpps.i.90, <4 x float>* %sse_cmp_min, align 16
  %36 = load <4 x float>, <4 x float>* %sse_v, align 16
  %37 = load <4 x float>, <4 x float>* %sse_max, align 16
  store <4 x float> %36, <4 x float>* %__a.addr.i.86, align 16
  store <4 x float> %37, <4 x float>* %__b.addr.i.87, align 16
  %38 = load <4 x float>, <4 x float>* %__b.addr.i.87, align 16
  %39 = load <4 x float>, <4 x float>* %__a.addr.i.86, align 16
  %cmpps.i = call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %38, <4 x float> %39, i8 1) #5
  store <4 x float> %cmpps.i, <4 x float>* %sse_cmp_max, align 16
  %40 = load <4 x float>, <4 x float>* %sse_min, align 16
  %41 = load <4 x float>, <4 x float>* %sse_v, align 16
  %42 = load <4 x float>, <4 x float>* %sse_cmp_min, align 16
  store <4 x float> %40, <4 x float>* %__V1.addr.i.83, align 16
  store <4 x float> %41, <4 x float>* %__V2.addr.i.84, align 16
  store <4 x float> %42, <4 x float>* %__M.addr.i.85, align 16
  %43 = load <4 x float>, <4 x float>* %__V1.addr.i.83, align 16
  %44 = load <4 x float>, <4 x float>* %__V2.addr.i.84, align 16
  %45 = load <4 x float>, <4 x float>* %__M.addr.i.85, align 16
  %46 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %43, <4 x float> %44, <4 x float> %45) #5
  store <4 x float> %46, <4 x float>* %sse_min, align 16
  %47 = load <4 x float>, <4 x float>* %sse_max, align 16
  %48 = load <4 x float>, <4 x float>* %sse_v, align 16
  %49 = load <4 x float>, <4 x float>* %sse_cmp_max, align 16
  store <4 x float> %47, <4 x float>* %__V1.addr.i.80, align 16
  store <4 x float> %48, <4 x float>* %__V2.addr.i.81, align 16
  store <4 x float> %49, <4 x float>* %__M.addr.i.82, align 16
  %50 = load <4 x float>, <4 x float>* %__V1.addr.i.80, align 16
  %51 = load <4 x float>, <4 x float>* %__V2.addr.i.81, align 16
  %52 = load <4 x float>, <4 x float>* %__M.addr.i.82, align 16
  %53 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %50, <4 x float> %51, <4 x float> %52) #5
  store <4 x float> %53, <4 x float>* %sse_max, align 16
  %54 = load <2 x i64>, <2 x i64>* %sse_idx_min, align 16
  %55 = bitcast <2 x i64> %54 to <4 x float>
  %56 = load <2 x i64>, <2 x i64>* %sse_idx, align 16
  %57 = bitcast <2 x i64> %56 to <4 x float>
  %58 = load <4 x float>, <4 x float>* %sse_cmp_min, align 16
  store <4 x float> %55, <4 x float>* %__V1.addr.i.77, align 16
  store <4 x float> %57, <4 x float>* %__V2.addr.i.78, align 16
  store <4 x float> %58, <4 x float>* %__M.addr.i.79, align 16
  %59 = load <4 x float>, <4 x float>* %__V1.addr.i.77, align 16
  %60 = load <4 x float>, <4 x float>* %__V2.addr.i.78, align 16
  %61 = load <4 x float>, <4 x float>* %__M.addr.i.79, align 16
  %62 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %59, <4 x float> %60, <4 x float> %61) #5
  %63 = bitcast <4 x float> %62 to <2 x i64>
  store <2 x i64> %63, <2 x i64>* %sse_idx_min, align 16
  %64 = load <2 x i64>, <2 x i64>* %sse_idx_max, align 16
  %65 = bitcast <2 x i64> %64 to <4 x float>
  %66 = load <2 x i64>, <2 x i64>* %sse_idx, align 16
  %67 = bitcast <2 x i64> %66 to <4 x float>
  %68 = load <4 x float>, <4 x float>* %sse_cmp_max, align 16
  store <4 x float> %65, <4 x float>* %__V1.addr.i, align 16
  store <4 x float> %67, <4 x float>* %__V2.addr.i, align 16
  store <4 x float> %68, <4 x float>* %__M.addr.i, align 16
  %69 = load <4 x float>, <4 x float>* %__V1.addr.i, align 16
  %70 = load <4 x float>, <4 x float>* %__V2.addr.i, align 16
  %71 = load <4 x float>, <4 x float>* %__M.addr.i, align 16
  %72 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %69, <4 x float> %70, <4 x float> %71) #5
  %73 = bitcast <4 x float> %72 to <2 x i64>
  store <2 x i64> %73, <2 x i64>* %sse_idx_max, align 16
  %74 = load <2 x i64>, <2 x i64>* %sse_idx, align 16
  %75 = load <2 x i64>, <2 x i64>* %sse_4, align 16
  store <2 x i64> %74, <2 x i64>* %__a.addr.i.76, align 16
  store <2 x i64> %75, <2 x i64>* %__b.addr.i, align 16
  %76 = load <2 x i64>, <2 x i64>* %__a.addr.i.76, align 16
  %77 = bitcast <2 x i64> %76 to <4 x i32>
  %78 = load <2 x i64>, <2 x i64>* %__b.addr.i, align 16
  %79 = bitcast <2 x i64> %78 to <4 x i32>
  %add.i = add <4 x i32> %77, %79
  %80 = bitcast <4 x i32> %add.i to <2 x i64>
  store <2 x i64> %80, <2 x i64>* %sse_idx, align 16
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %81 = load i32, i32* %i, align 4
  %add = add i32 %81, 4
  store i32 %add, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %arraydecay = getelementptr inbounds [4 x float], [4 x float]* %mins, i32 0, i32 0
  %82 = load <4 x float>, <4 x float>* %sse_min, align 16
  store float* %arraydecay, float** %__p.addr.i.74, align 8
  store <4 x float> %82, <4 x float>* %__a.addr.i.75, align 16
  %83 = load <4 x float>, <4 x float>* %__a.addr.i.75, align 16
  %84 = load float*, float** %__p.addr.i.74, align 8
  %85 = bitcast float* %84 to <4 x float>*
  store <4 x float> %83, <4 x float>* %85, align 16
  %arraydecay16 = getelementptr inbounds [4 x float], [4 x float]* %maxs, i32 0, i32 0
  %86 = load <4 x float>, <4 x float>* %sse_max, align 16
  store float* %arraydecay16, float** %__p.addr.i, align 8
  store <4 x float> %86, <4 x float>* %__a.addr.i, align 16
  %87 = load <4 x float>, <4 x float>* %__a.addr.i, align 16
  %88 = load float*, float** %__p.addr.i, align 8
  %89 = bitcast float* %88 to <4 x float>*
  store <4 x float> %87, <4 x float>* %89, align 16
  %arrayidx17 = getelementptr inbounds [4 x float], [4 x float]* %mins, i32 0, i64 0
  %90 = load float, float* %arrayidx17, align 4
  store float %90, float* %min, align 4
  %arrayidx18 = getelementptr inbounds [4 x float], [4 x float]* %maxs, i32 0, i64 0
  %91 = load float, float* %arrayidx18, align 4
  store float %91, float* %max, align 4
  %92 = load <2 x i64>, <2 x i64>* %sse_idx_min, align 16
  %93 = bitcast <2 x i64> %92 to <4 x i32>
  store <4 x i32> %93, <4 x i32>* %__a, align 16
  %94 = load <4 x i32>, <4 x i32>* %__a, align 16
  %vecext = extractelement <4 x i32> %94, i32 0
  store i32 %vecext, i32* %tmp
  %95 = load i32, i32* %tmp
  store i32 %95, i32* %idx_min, align 4
  %96 = load <2 x i64>, <2 x i64>* %sse_idx_max, align 16
  %97 = bitcast <2 x i64> %96 to <4 x i32>
  store <4 x i32> %97, <4 x i32>* %__a21, align 16
  %98 = load <4 x i32>, <4 x i32>* %__a21, align 16
  %vecext23 = extractelement <4 x i32> %98, i32 0
  store i32 %vecext23, i32* %tmp22
  %99 = load i32, i32* %tmp22
  store i32 %99, i32* %idx_max, align 4
  store i32 1, i32* %i25, align 4
  br label %for.cond.26

for.cond.26:                                      ; preds = %for.inc.51, %for.end
  %100 = load i32, i32* %i25, align 4
  %cmp27 = icmp slt i32 %100, 4
  br i1 %cmp27, label %for.body.29, label %for.end.52

for.body.29:                                      ; preds = %for.cond.26
  %101 = load i32, i32* %i25, align 4
  %idxprom31 = sext i32 %101 to i64
  %arrayidx32 = getelementptr inbounds [4 x float], [4 x float]* %mins, i32 0, i64 %idxprom31
  %102 = load float, float* %arrayidx32, align 4
  store float %102, float* %v, align 4
  %103 = load float, float* %v, align 4
  %104 = load float, float* %min, align 4
  %cmp33 = fcmp olt float %103, %104
  br i1 %cmp33, label %if.then, label %if.end

if.then:                                          ; preds = %for.body.29
  %105 = load float, float* %v, align 4
  store float %105, float* %min, align 4
  %106 = load <2 x i64>, <2 x i64>* %sse_idx_min, align 16
  %107 = bitcast <2 x i64> %106 to <4 x i32>
  store <4 x i32> %107, <4 x i32>* %__a36, align 16
  %108 = load <4 x i32>, <4 x i32>* %__a36, align 16
  %109 = load i32, i32* %i25, align 4
  %and38 = and i32 %109, 3
  %vecext39 = extractelement <4 x i32> %108, i32 %and38
  store i32 %vecext39, i32* %tmp37
  %110 = load i32, i32* %tmp37
  store i32 %110, i32* %idx_min, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body.29
  %111 = load i32, i32* %i25, align 4
  %idxprom40 = sext i32 %111 to i64
  %arrayidx41 = getelementptr inbounds [4 x float], [4 x float]* %maxs, i32 0, i64 %idxprom40
  %112 = load float, float* %arrayidx41, align 4
  store float %112, float* %v, align 4
  %113 = load float, float* %v, align 4
  %114 = load float, float* %max, align 4
  %cmp42 = fcmp ogt float %113, %114
  br i1 %cmp42, label %if.then.44, label %if.end.50

if.then.44:                                       ; preds = %if.end
  %115 = load float, float* %v, align 4
  store float %115, float* %max, align 4
  %116 = load <2 x i64>, <2 x i64>* %sse_idx_max, align 16
  %117 = bitcast <2 x i64> %116 to <4 x i32>
  store <4 x i32> %117, <4 x i32>* %__a46, align 16
  %118 = load <4 x i32>, <4 x i32>* %__a46, align 16
  %119 = load i32, i32* %i25, align 4
  %and48 = and i32 %119, 3
  %vecext49 = extractelement <4 x i32> %118, i32 %and48
  store i32 %vecext49, i32* %tmp47
  %120 = load i32, i32* %tmp47
  store i32 %120, i32* %idx_max, align 4
  br label %if.end.50

if.end.50:                                        ; preds = %if.then.44, %if.end
  br label %for.inc.51

for.inc.51:                                       ; preds = %if.end.50
  %121 = load i32, i32* %i25, align 4
  %inc = add nsw i32 %121, 1
  store i32 %inc, i32* %i25, align 4
  br label %for.cond.26

for.end.52:                                       ; preds = %for.cond.26
  %122 = load i32, i32* %n_sse, align 4
  store i32 %122, i32* %i54, align 4
  br label %for.cond.55

for.cond.55:                                      ; preds = %for.inc.71, %for.end.52
  %123 = load i32, i32* %i54, align 4
  %124 = load i32, i32* %n.addr, align 4
  %cmp56 = icmp ult i32 %123, %124
  br i1 %cmp56, label %for.body.58, label %for.end.73

for.body.58:                                      ; preds = %for.cond.55
  %125 = load i32, i32* %i54, align 4
  %idxprom61 = zext i32 %125 to i64
  %126 = load float*, float** %buf.addr, align 8
  %arrayidx62 = getelementptr inbounds float, float* %126, i64 %idxprom61
  %127 = load float, float* %arrayidx62, align 4
  store float %127, float* %v60, align 4
  %128 = load float, float* %v60, align 4
  %129 = load float, float* %min, align 4
  %cmp63 = fcmp olt float %128, %129
  br i1 %cmp63, label %if.then.65, label %if.end.66

if.then.65:                                       ; preds = %for.body.58
  %130 = load float, float* %v60, align 4
  store float %130, float* %min, align 4
  %131 = load i32, i32* %i54, align 4
  store i32 %131, i32* %idx_min, align 4
  br label %if.end.66

if.end.66:                                        ; preds = %if.then.65, %for.body.58
  %132 = load float, float* %v60, align 4
  %133 = load float, float* %max, align 4
  %cmp67 = fcmp ogt float %132, %133
  br i1 %cmp67, label %if.then.69, label %if.end.70

if.then.69:                                       ; preds = %if.end.66
  %134 = load float, float* %v60, align 4
  store float %134, float* %max, align 4
  %135 = load i32, i32* %i54, align 4
  store i32 %135, i32* %idx_max, align 4
  br label %if.end.70

if.end.70:                                        ; preds = %if.then.69, %if.end.66
  br label %for.inc.71

for.inc.71:                                       ; preds = %if.end.70
  %136 = load i32, i32* %i54, align 4
  %inc72 = add i32 %136, 1
  store i32 %inc72, i32* %i54, align 4
  br label %for.cond.55

for.end.73:                                       ; preds = %for.cond.55
  %137 = load i32, i32* %idx_min, align 4
  %138 = load i32*, i32** %idx_min_.addr, align 8
  store i32 %137, i32* %138, align 4
  %139 = load float, float* %min, align 4
  %140 = load float*, float** %min_.addr, align 8
  store float %139, float* %140, align 4
  %141 = load i32, i32* %idx_max, align 4
  %142 = load i32*, i32** %idx_max_.addr, align 8
  store i32 %141, i32* %142, align 4
  %143 = load float, float* %max, align 4
  %144 = load float*, float** %max_.addr, align 8
  store float %143, float* %144, align 4
  ret void
}

; Function Attrs: nounwind uwtable
define void @minmax_vec2(i32 %n, float* %buf, i32* %idx_min_, i32* %idx_max_, float* %min_, float* %max_) #0 {
entry:
  %.compoundliteral.i.205 = alloca <2 x i64>, align 16
  %__w.addr.i.199 = alloca float, align 4
  %.compoundliteral.i.200 = alloca <4 x float>, align 16
  %__w.addr.i = alloca float, align 4
  %.compoundliteral.i.194 = alloca <4 x float>, align 16
  %i3.addr.i = alloca i32, align 4
  %i2.addr.i = alloca i32, align 4
  %i1.addr.i = alloca i32, align 4
  %i0.addr.i = alloca i32, align 4
  %.compoundliteral.i.189 = alloca <4 x i32>, align 16
  %__i.addr.i.183 = alloca i32, align 4
  %.compoundliteral.i.184 = alloca <4 x i32>, align 16
  %__p.addr.i.182 = alloca float*, align 8
  %__a.addr.i.179 = alloca <4 x float>, align 16
  %__b.addr.i.180 = alloca <4 x float>, align 16
  %__a.addr.i.176 = alloca <4 x float>, align 16
  %__b.addr.i.177 = alloca <4 x float>, align 16
  %__V1.addr.i.173 = alloca <4 x float>, align 16
  %__V2.addr.i.174 = alloca <4 x float>, align 16
  %__M.addr.i.175 = alloca <4 x float>, align 16
  %__V1.addr.i.170 = alloca <4 x float>, align 16
  %__V2.addr.i.171 = alloca <4 x float>, align 16
  %__M.addr.i.172 = alloca <4 x float>, align 16
  %__V1.addr.i.167 = alloca <4 x float>, align 16
  %__V2.addr.i.168 = alloca <4 x float>, align 16
  %__M.addr.i.169 = alloca <4 x float>, align 16
  %__V1.addr.i.164 = alloca <4 x float>, align 16
  %__V2.addr.i.165 = alloca <4 x float>, align 16
  %__M.addr.i.166 = alloca <4 x float>, align 16
  %__a.addr.i.162 = alloca <2 x i64>, align 16
  %__b.addr.i.163 = alloca <2 x i64>, align 16
  %__i.addr.i.156 = alloca i32, align 4
  %.compoundliteral.i.157 = alloca <4 x i32>, align 16
  %__i.addr.i.150 = alloca i32, align 4
  %.compoundliteral.i.151 = alloca <4 x i32>, align 16
  %__i.addr.i.144 = alloca i32, align 4
  %.compoundliteral.i.145 = alloca <4 x i32>, align 16
  %__i.addr.i.138 = alloca i32, align 4
  %.compoundliteral.i.139 = alloca <4 x i32>, align 16
  %__a.addr.i.135 = alloca <4 x float>, align 16
  %__b.addr.i.136 = alloca <4 x float>, align 16
  %__a.addr.i.132 = alloca <4 x float>, align 16
  %__b.addr.i.133 = alloca <4 x float>, align 16
  %__V1.addr.i.129 = alloca <4 x float>, align 16
  %__V2.addr.i.130 = alloca <4 x float>, align 16
  %__M.addr.i.131 = alloca <4 x float>, align 16
  %__V1.addr.i.126 = alloca <4 x float>, align 16
  %__V2.addr.i.127 = alloca <4 x float>, align 16
  %__M.addr.i.128 = alloca <4 x float>, align 16
  %__V1.addr.i.123 = alloca <4 x float>, align 16
  %__V2.addr.i.124 = alloca <4 x float>, align 16
  %__M.addr.i.125 = alloca <4 x float>, align 16
  %__V1.addr.i.120 = alloca <4 x float>, align 16
  %__V2.addr.i.121 = alloca <4 x float>, align 16
  %__M.addr.i.122 = alloca <4 x float>, align 16
  %__i.addr.i.114 = alloca i32, align 4
  %.compoundliteral.i.115 = alloca <4 x i32>, align 16
  %__i.addr.i.108 = alloca i32, align 4
  %.compoundliteral.i.109 = alloca <4 x i32>, align 16
  %__i.addr.i.102 = alloca i32, align 4
  %.compoundliteral.i.103 = alloca <4 x i32>, align 16
  %__i.addr.i = alloca i32, align 4
  %.compoundliteral.i.101 = alloca <4 x i32>, align 16
  %__a.addr.i.98 = alloca <4 x float>, align 16
  %__b.addr.i.99 = alloca <4 x float>, align 16
  %__a.addr.i.97 = alloca <4 x float>, align 16
  %__b.addr.i = alloca <4 x float>, align 16
  %__V1.addr.i.94 = alloca <4 x float>, align 16
  %__V2.addr.i.95 = alloca <4 x float>, align 16
  %__M.addr.i.96 = alloca <4 x float>, align 16
  %__V1.addr.i.91 = alloca <4 x float>, align 16
  %__V2.addr.i.92 = alloca <4 x float>, align 16
  %__M.addr.i.93 = alloca <4 x float>, align 16
  %__V1.addr.i.88 = alloca <4 x float>, align 16
  %__V2.addr.i.89 = alloca <4 x float>, align 16
  %__M.addr.i.90 = alloca <4 x float>, align 16
  %__V1.addr.i = alloca <4 x float>, align 16
  %__V2.addr.i = alloca <4 x float>, align 16
  %__M.addr.i = alloca <4 x float>, align 16
  %__p.addr.i.84 = alloca float*, align 8
  %__a.addr.i.85 = alloca <4 x float>, align 16
  %__p.addr.i = alloca float*, align 8
  %__a.addr.i = alloca <4 x float>, align 16
  %.compoundliteral.i = alloca <2 x i64>, align 16
  %n.addr = alloca i32, align 4
  %buf.addr = alloca float*, align 8
  %idx_min_.addr = alloca i32*, align 8
  %idx_max_.addr = alloca i32*, align 8
  %min_.addr = alloca float*, align 8
  %max_.addr = alloca float*, align 8
  %sse_idx_min = alloca <2 x i64>, align 16
  %sse_idx_max = alloca <2 x i64>, align 16
  %sse_min = alloca <4 x float>, align 16
  %sse_max = alloca <4 x float>, align 16
  %n_sse = alloca i32, align 4
  %sse_idx = alloca <2 x i64>, align 16
  %sse_4 = alloca <2 x i64>, align 16
  %i = alloca i32, align 4
  %sse_v = alloca <4 x float>, align 16
  %sse_cmp_min = alloca <4 x float>, align 16
  %sse_cmp_max = alloca <4 x float>, align 16
  %sse_min_permute = alloca <4 x float>, align 16
  %tmp = alloca <2 x i64>, align 16
  %sse_max_permute = alloca <4 x float>, align 16
  %tmp18 = alloca <2 x i64>, align 16
  %sse_idx_min_permute = alloca <2 x i64>, align 16
  %tmp22 = alloca <2 x i64>, align 16
  %sse_idx_max_permute = alloca <2 x i64>, align 16
  %tmp26 = alloca <2 x i64>, align 16
  %sse_cmp_min30 = alloca <4 x float>, align 16
  %sse_cmp_max33 = alloca <4 x float>, align 16
  %tmp39 = alloca <2 x i64>, align 16
  %tmp42 = alloca <2 x i64>, align 16
  %tmp45 = alloca <2 x i64>, align 16
  %tmp48 = alloca <2 x i64>, align 16
  %min = alloca float, align 4
  %max = alloca float, align 4
  %idx_min = alloca i32, align 4
  %idx_max = alloca i32, align 4
  %__a = alloca <4 x i32>, align 16
  %tmp62 = alloca i32, align 4
  %__a64 = alloca <4 x i32>, align 16
  %tmp65 = alloca i32, align 4
  %i68 = alloca i32, align 4
  %v = alloca float, align 4
  store i32 %n, i32* %n.addr, align 4
  store float* %buf, float** %buf.addr, align 8
  store i32* %idx_min_, i32** %idx_min_.addr, align 8
  store i32* %idx_max_, i32** %idx_max_.addr, align 8
  store float* %min_, float** %min_.addr, align 8
  store float* %max_, float** %max_.addr, align 8
  store <2 x i64> zeroinitializer, <2 x i64>* %.compoundliteral.i
  %0 = load <2 x i64>, <2 x i64>* %.compoundliteral.i
  store <2 x i64> %0, <2 x i64>* %sse_idx_min, align 16
  store <2 x i64> zeroinitializer, <2 x i64>* %.compoundliteral.i.205
  %1 = load <2 x i64>, <2 x i64>* %.compoundliteral.i.205
  store <2 x i64> %1, <2 x i64>* %sse_idx_max, align 16
  store float 0x47EFFFFFE0000000, float* %__w.addr.i.199, align 4
  %2 = load float, float* %__w.addr.i.199, align 4
  %vecinit.i.201 = insertelement <4 x float> undef, float %2, i32 0
  %3 = load float, float* %__w.addr.i.199, align 4
  %vecinit1.i.202 = insertelement <4 x float> %vecinit.i.201, float %3, i32 1
  %4 = load float, float* %__w.addr.i.199, align 4
  %vecinit2.i.203 = insertelement <4 x float> %vecinit1.i.202, float %4, i32 2
  %5 = load float, float* %__w.addr.i.199, align 4
  %vecinit3.i.204 = insertelement <4 x float> %vecinit2.i.203, float %5, i32 3
  store <4 x float> %vecinit3.i.204, <4 x float>* %.compoundliteral.i.200
  %6 = load <4 x float>, <4 x float>* %.compoundliteral.i.200
  store <4 x float> %6, <4 x float>* %sse_min, align 16
  store float 0x3810000000000000, float* %__w.addr.i, align 4
  %7 = load float, float* %__w.addr.i, align 4
  %vecinit.i.195 = insertelement <4 x float> undef, float %7, i32 0
  %8 = load float, float* %__w.addr.i, align 4
  %vecinit1.i.196 = insertelement <4 x float> %vecinit.i.195, float %8, i32 1
  %9 = load float, float* %__w.addr.i, align 4
  %vecinit2.i.197 = insertelement <4 x float> %vecinit1.i.196, float %9, i32 2
  %10 = load float, float* %__w.addr.i, align 4
  %vecinit3.i.198 = insertelement <4 x float> %vecinit2.i.197, float %10, i32 3
  store <4 x float> %vecinit3.i.198, <4 x float>* %.compoundliteral.i.194
  %11 = load <4 x float>, <4 x float>* %.compoundliteral.i.194
  store <4 x float> %11, <4 x float>* %sse_max, align 16
  %12 = load i32, i32* %n.addr, align 4
  %conv = zext i32 %12 to i64
  %and = and i64 %conv, -4
  %conv4 = trunc i64 %and to i32
  store i32 %conv4, i32* %n_sse, align 4
  store i32 3, i32* %i3.addr.i, align 4
  store i32 2, i32* %i2.addr.i, align 4
  store i32 1, i32* %i1.addr.i, align 4
  store i32 0, i32* %i0.addr.i, align 4
  %13 = load i32, i32* %i0.addr.i, align 4
  %vecinit.i.190 = insertelement <4 x i32> undef, i32 %13, i32 0
  %14 = load i32, i32* %i1.addr.i, align 4
  %vecinit1.i.191 = insertelement <4 x i32> %vecinit.i.190, i32 %14, i32 1
  %15 = load i32, i32* %i2.addr.i, align 4
  %vecinit2.i.192 = insertelement <4 x i32> %vecinit1.i.191, i32 %15, i32 2
  %16 = load i32, i32* %i3.addr.i, align 4
  %vecinit3.i.193 = insertelement <4 x i32> %vecinit2.i.192, i32 %16, i32 3
  store <4 x i32> %vecinit3.i.193, <4 x i32>* %.compoundliteral.i.189
  %17 = load <4 x i32>, <4 x i32>* %.compoundliteral.i.189
  %18 = bitcast <4 x i32> %17 to <2 x i64>
  store <2 x i64> %18, <2 x i64>* %sse_idx, align 16
  store i32 4, i32* %__i.addr.i.183, align 4
  %19 = load i32, i32* %__i.addr.i.183, align 4
  %vecinit.i.185 = insertelement <4 x i32> undef, i32 %19, i32 0
  %20 = load i32, i32* %__i.addr.i.183, align 4
  %vecinit1.i.186 = insertelement <4 x i32> %vecinit.i.185, i32 %20, i32 1
  %21 = load i32, i32* %__i.addr.i.183, align 4
  %vecinit2.i.187 = insertelement <4 x i32> %vecinit1.i.186, i32 %21, i32 2
  %22 = load i32, i32* %__i.addr.i.183, align 4
  %vecinit3.i.188 = insertelement <4 x i32> %vecinit2.i.187, i32 %22, i32 3
  store <4 x i32> %vecinit3.i.188, <4 x i32>* %.compoundliteral.i.184
  %23 = load <4 x i32>, <4 x i32>* %.compoundliteral.i.184
  %24 = bitcast <4 x i32> %23 to <2 x i64>
  store <2 x i64> %24, <2 x i64>* %sse_4, align 16
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %25 = load i32, i32* %i, align 4
  %26 = load i32, i32* %n_sse, align 4
  %cmp = icmp ult i32 %25, %26
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %27 = load i32, i32* %i, align 4
  %idxprom = zext i32 %27 to i64
  %28 = load float*, float** %buf.addr, align 8
  %arrayidx = getelementptr inbounds float, float* %28, i64 %idxprom
  store float* %arrayidx, float** %__p.addr.i.182, align 8
  %29 = load float*, float** %__p.addr.i.182, align 8
  %30 = bitcast float* %29 to <4 x float>*
  %31 = load <4 x float>, <4 x float>* %30, align 16
  store <4 x float> %31, <4 x float>* %sse_v, align 16
  %32 = load <4 x float>, <4 x float>* %sse_v, align 16
  %33 = load <4 x float>, <4 x float>* %sse_min, align 16
  store <4 x float> %32, <4 x float>* %__a.addr.i.179, align 16
  store <4 x float> %33, <4 x float>* %__b.addr.i.180, align 16
  %34 = load <4 x float>, <4 x float>* %__a.addr.i.179, align 16
  %35 = load <4 x float>, <4 x float>* %__b.addr.i.180, align 16
  %cmpps.i.181 = call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %34, <4 x float> %35, i8 1) #5
  store <4 x float> %cmpps.i.181, <4 x float>* %sse_cmp_min, align 16
  %36 = load <4 x float>, <4 x float>* %sse_v, align 16
  %37 = load <4 x float>, <4 x float>* %sse_max, align 16
  store <4 x float> %36, <4 x float>* %__a.addr.i.176, align 16
  store <4 x float> %37, <4 x float>* %__b.addr.i.177, align 16
  %38 = load <4 x float>, <4 x float>* %__b.addr.i.177, align 16
  %39 = load <4 x float>, <4 x float>* %__a.addr.i.176, align 16
  %cmpps.i.178 = call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %38, <4 x float> %39, i8 1) #5
  store <4 x float> %cmpps.i.178, <4 x float>* %sse_cmp_max, align 16
  %40 = load <4 x float>, <4 x float>* %sse_min, align 16
  %41 = load <4 x float>, <4 x float>* %sse_v, align 16
  %42 = load <4 x float>, <4 x float>* %sse_cmp_min, align 16
  store <4 x float> %40, <4 x float>* %__V1.addr.i.173, align 16
  store <4 x float> %41, <4 x float>* %__V2.addr.i.174, align 16
  store <4 x float> %42, <4 x float>* %__M.addr.i.175, align 16
  %43 = load <4 x float>, <4 x float>* %__V1.addr.i.173, align 16
  %44 = load <4 x float>, <4 x float>* %__V2.addr.i.174, align 16
  %45 = load <4 x float>, <4 x float>* %__M.addr.i.175, align 16
  %46 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %43, <4 x float> %44, <4 x float> %45) #5
  store <4 x float> %46, <4 x float>* %sse_min, align 16
  %47 = load <4 x float>, <4 x float>* %sse_max, align 16
  %48 = load <4 x float>, <4 x float>* %sse_v, align 16
  %49 = load <4 x float>, <4 x float>* %sse_cmp_max, align 16
  store <4 x float> %47, <4 x float>* %__V1.addr.i.170, align 16
  store <4 x float> %48, <4 x float>* %__V2.addr.i.171, align 16
  store <4 x float> %49, <4 x float>* %__M.addr.i.172, align 16
  %50 = load <4 x float>, <4 x float>* %__V1.addr.i.170, align 16
  %51 = load <4 x float>, <4 x float>* %__V2.addr.i.171, align 16
  %52 = load <4 x float>, <4 x float>* %__M.addr.i.172, align 16
  %53 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %50, <4 x float> %51, <4 x float> %52) #5
  store <4 x float> %53, <4 x float>* %sse_max, align 16
  %54 = load <2 x i64>, <2 x i64>* %sse_idx_min, align 16
  %55 = bitcast <2 x i64> %54 to <4 x float>
  %56 = load <2 x i64>, <2 x i64>* %sse_idx, align 16
  %57 = bitcast <2 x i64> %56 to <4 x float>
  %58 = load <4 x float>, <4 x float>* %sse_cmp_min, align 16
  store <4 x float> %55, <4 x float>* %__V1.addr.i.167, align 16
  store <4 x float> %57, <4 x float>* %__V2.addr.i.168, align 16
  store <4 x float> %58, <4 x float>* %__M.addr.i.169, align 16
  %59 = load <4 x float>, <4 x float>* %__V1.addr.i.167, align 16
  %60 = load <4 x float>, <4 x float>* %__V2.addr.i.168, align 16
  %61 = load <4 x float>, <4 x float>* %__M.addr.i.169, align 16
  %62 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %59, <4 x float> %60, <4 x float> %61) #5
  %63 = bitcast <4 x float> %62 to <2 x i64>
  store <2 x i64> %63, <2 x i64>* %sse_idx_min, align 16
  %64 = load <2 x i64>, <2 x i64>* %sse_idx_max, align 16
  %65 = bitcast <2 x i64> %64 to <4 x float>
  %66 = load <2 x i64>, <2 x i64>* %sse_idx, align 16
  %67 = bitcast <2 x i64> %66 to <4 x float>
  %68 = load <4 x float>, <4 x float>* %sse_cmp_max, align 16
  store <4 x float> %65, <4 x float>* %__V1.addr.i.164, align 16
  store <4 x float> %67, <4 x float>* %__V2.addr.i.165, align 16
  store <4 x float> %68, <4 x float>* %__M.addr.i.166, align 16
  %69 = load <4 x float>, <4 x float>* %__V1.addr.i.164, align 16
  %70 = load <4 x float>, <4 x float>* %__V2.addr.i.165, align 16
  %71 = load <4 x float>, <4 x float>* %__M.addr.i.166, align 16
  %72 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %69, <4 x float> %70, <4 x float> %71) #5
  %73 = bitcast <4 x float> %72 to <2 x i64>
  store <2 x i64> %73, <2 x i64>* %sse_idx_max, align 16
  %74 = load <2 x i64>, <2 x i64>* %sse_idx, align 16
  %75 = load <2 x i64>, <2 x i64>* %sse_4, align 16
  store <2 x i64> %74, <2 x i64>* %__a.addr.i.162, align 16
  store <2 x i64> %75, <2 x i64>* %__b.addr.i.163, align 16
  %76 = load <2 x i64>, <2 x i64>* %__a.addr.i.162, align 16
  %77 = bitcast <2 x i64> %76 to <4 x i32>
  %78 = load <2 x i64>, <2 x i64>* %__b.addr.i.163, align 16
  %79 = bitcast <2 x i64> %78 to <4 x i32>
  %add.i = add <4 x i32> %77, %79
  %80 = bitcast <4 x i32> %add.i to <2 x i64>
  store <2 x i64> %80, <2 x i64>* %sse_idx, align 16
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %81 = load i32, i32* %i, align 4
  %add = add i32 %81, 4
  store i32 %add, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %82 = load <4 x float>, <4 x float>* %sse_min, align 16
  %83 = bitcast <4 x float> %82 to <2 x i64>
  %84 = bitcast <2 x i64> %83 to <4 x i32>
  store i32 0, i32* %__i.addr.i.156, align 4
  %85 = load i32, i32* %__i.addr.i.156, align 4
  %vecinit.i.158 = insertelement <4 x i32> undef, i32 %85, i32 0
  %86 = load i32, i32* %__i.addr.i.156, align 4
  %vecinit1.i.159 = insertelement <4 x i32> %vecinit.i.158, i32 %86, i32 1
  %87 = load i32, i32* %__i.addr.i.156, align 4
  %vecinit2.i.160 = insertelement <4 x i32> %vecinit1.i.159, i32 %87, i32 2
  %88 = load i32, i32* %__i.addr.i.156, align 4
  %vecinit3.i.161 = insertelement <4 x i32> %vecinit2.i.160, i32 %88, i32 3
  store <4 x i32> %vecinit3.i.161, <4 x i32>* %.compoundliteral.i.157
  %89 = load <4 x i32>, <4 x i32>* %.compoundliteral.i.157
  %90 = bitcast <4 x i32> %89 to <2 x i64>
  %91 = bitcast <2 x i64> %90 to <4 x i32>
  %shuffle = shufflevector <4 x i32> %84, <4 x i32> %91, <4 x i32> <i32 2, i32 3, i32 0, i32 0>
  %92 = bitcast <4 x i32> %shuffle to <2 x i64>
  store <2 x i64> %92, <2 x i64>* %tmp
  %93 = load <2 x i64>, <2 x i64>* %tmp
  %94 = bitcast <2 x i64> %93 to <4 x float>
  store <4 x float> %94, <4 x float>* %sse_min_permute, align 16
  %95 = load <4 x float>, <4 x float>* %sse_max, align 16
  %96 = bitcast <4 x float> %95 to <2 x i64>
  %97 = bitcast <2 x i64> %96 to <4 x i32>
  store i32 0, i32* %__i.addr.i.150, align 4
  %98 = load i32, i32* %__i.addr.i.150, align 4
  %vecinit.i.152 = insertelement <4 x i32> undef, i32 %98, i32 0
  %99 = load i32, i32* %__i.addr.i.150, align 4
  %vecinit1.i.153 = insertelement <4 x i32> %vecinit.i.152, i32 %99, i32 1
  %100 = load i32, i32* %__i.addr.i.150, align 4
  %vecinit2.i.154 = insertelement <4 x i32> %vecinit1.i.153, i32 %100, i32 2
  %101 = load i32, i32* %__i.addr.i.150, align 4
  %vecinit3.i.155 = insertelement <4 x i32> %vecinit2.i.154, i32 %101, i32 3
  store <4 x i32> %vecinit3.i.155, <4 x i32>* %.compoundliteral.i.151
  %102 = load <4 x i32>, <4 x i32>* %.compoundliteral.i.151
  %103 = bitcast <4 x i32> %102 to <2 x i64>
  %104 = bitcast <2 x i64> %103 to <4 x i32>
  %shuffle20 = shufflevector <4 x i32> %97, <4 x i32> %104, <4 x i32> <i32 2, i32 3, i32 0, i32 0>
  %105 = bitcast <4 x i32> %shuffle20 to <2 x i64>
  store <2 x i64> %105, <2 x i64>* %tmp18
  %106 = load <2 x i64>, <2 x i64>* %tmp18
  %107 = bitcast <2 x i64> %106 to <4 x float>
  store <4 x float> %107, <4 x float>* %sse_max_permute, align 16
  %108 = load <2 x i64>, <2 x i64>* %sse_idx_min, align 16
  %109 = bitcast <2 x i64> %108 to <4 x i32>
  store i32 0, i32* %__i.addr.i.144, align 4
  %110 = load i32, i32* %__i.addr.i.144, align 4
  %vecinit.i.146 = insertelement <4 x i32> undef, i32 %110, i32 0
  %111 = load i32, i32* %__i.addr.i.144, align 4
  %vecinit1.i.147 = insertelement <4 x i32> %vecinit.i.146, i32 %111, i32 1
  %112 = load i32, i32* %__i.addr.i.144, align 4
  %vecinit2.i.148 = insertelement <4 x i32> %vecinit1.i.147, i32 %112, i32 2
  %113 = load i32, i32* %__i.addr.i.144, align 4
  %vecinit3.i.149 = insertelement <4 x i32> %vecinit2.i.148, i32 %113, i32 3
  store <4 x i32> %vecinit3.i.149, <4 x i32>* %.compoundliteral.i.145
  %114 = load <4 x i32>, <4 x i32>* %.compoundliteral.i.145
  %115 = bitcast <4 x i32> %114 to <2 x i64>
  %116 = bitcast <2 x i64> %115 to <4 x i32>
  %shuffle24 = shufflevector <4 x i32> %109, <4 x i32> %116, <4 x i32> <i32 2, i32 3, i32 0, i32 0>
  %117 = bitcast <4 x i32> %shuffle24 to <2 x i64>
  store <2 x i64> %117, <2 x i64>* %tmp22
  %118 = load <2 x i64>, <2 x i64>* %tmp22
  store <2 x i64> %118, <2 x i64>* %sse_idx_min_permute, align 16
  %119 = load <2 x i64>, <2 x i64>* %sse_idx_max, align 16
  %120 = bitcast <2 x i64> %119 to <4 x i32>
  store i32 0, i32* %__i.addr.i.138, align 4
  %121 = load i32, i32* %__i.addr.i.138, align 4
  %vecinit.i.140 = insertelement <4 x i32> undef, i32 %121, i32 0
  %122 = load i32, i32* %__i.addr.i.138, align 4
  %vecinit1.i.141 = insertelement <4 x i32> %vecinit.i.140, i32 %122, i32 1
  %123 = load i32, i32* %__i.addr.i.138, align 4
  %vecinit2.i.142 = insertelement <4 x i32> %vecinit1.i.141, i32 %123, i32 2
  %124 = load i32, i32* %__i.addr.i.138, align 4
  %vecinit3.i.143 = insertelement <4 x i32> %vecinit2.i.142, i32 %124, i32 3
  store <4 x i32> %vecinit3.i.143, <4 x i32>* %.compoundliteral.i.139
  %125 = load <4 x i32>, <4 x i32>* %.compoundliteral.i.139
  %126 = bitcast <4 x i32> %125 to <2 x i64>
  %127 = bitcast <2 x i64> %126 to <4 x i32>
  %shuffle28 = shufflevector <4 x i32> %120, <4 x i32> %127, <4 x i32> <i32 2, i32 3, i32 0, i32 0>
  %128 = bitcast <4 x i32> %shuffle28 to <2 x i64>
  store <2 x i64> %128, <2 x i64>* %tmp26
  %129 = load <2 x i64>, <2 x i64>* %tmp26
  store <2 x i64> %129, <2 x i64>* %sse_idx_max_permute, align 16
  %130 = load <4 x float>, <4 x float>* %sse_min_permute, align 16
  %131 = load <4 x float>, <4 x float>* %sse_min, align 16
  store <4 x float> %130, <4 x float>* %__a.addr.i.135, align 16
  store <4 x float> %131, <4 x float>* %__b.addr.i.136, align 16
  %132 = load <4 x float>, <4 x float>* %__a.addr.i.135, align 16
  %133 = load <4 x float>, <4 x float>* %__b.addr.i.136, align 16
  %cmpps.i.137 = call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %132, <4 x float> %133, i8 1) #5
  store <4 x float> %cmpps.i.137, <4 x float>* %sse_cmp_min30, align 16
  %134 = load <4 x float>, <4 x float>* %sse_max_permute, align 16
  %135 = load <4 x float>, <4 x float>* %sse_max, align 16
  store <4 x float> %134, <4 x float>* %__a.addr.i.132, align 16
  store <4 x float> %135, <4 x float>* %__b.addr.i.133, align 16
  %136 = load <4 x float>, <4 x float>* %__b.addr.i.133, align 16
  %137 = load <4 x float>, <4 x float>* %__a.addr.i.132, align 16
  %cmpps.i.134 = call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %136, <4 x float> %137, i8 1) #5
  store <4 x float> %cmpps.i.134, <4 x float>* %sse_cmp_max33, align 16
  %138 = load <4 x float>, <4 x float>* %sse_min, align 16
  %139 = load <4 x float>, <4 x float>* %sse_min_permute, align 16
  %140 = load <4 x float>, <4 x float>* %sse_cmp_min30, align 16
  store <4 x float> %138, <4 x float>* %__V1.addr.i.129, align 16
  store <4 x float> %139, <4 x float>* %__V2.addr.i.130, align 16
  store <4 x float> %140, <4 x float>* %__M.addr.i.131, align 16
  %141 = load <4 x float>, <4 x float>* %__V1.addr.i.129, align 16
  %142 = load <4 x float>, <4 x float>* %__V2.addr.i.130, align 16
  %143 = load <4 x float>, <4 x float>* %__M.addr.i.131, align 16
  %144 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %141, <4 x float> %142, <4 x float> %143) #5
  store <4 x float> %144, <4 x float>* %sse_min, align 16
  %145 = load <4 x float>, <4 x float>* %sse_max, align 16
  %146 = load <4 x float>, <4 x float>* %sse_max_permute, align 16
  %147 = load <4 x float>, <4 x float>* %sse_cmp_max33, align 16
  store <4 x float> %145, <4 x float>* %__V1.addr.i.126, align 16
  store <4 x float> %146, <4 x float>* %__V2.addr.i.127, align 16
  store <4 x float> %147, <4 x float>* %__M.addr.i.128, align 16
  %148 = load <4 x float>, <4 x float>* %__V1.addr.i.126, align 16
  %149 = load <4 x float>, <4 x float>* %__V2.addr.i.127, align 16
  %150 = load <4 x float>, <4 x float>* %__M.addr.i.128, align 16
  %151 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %148, <4 x float> %149, <4 x float> %150) #5
  store <4 x float> %151, <4 x float>* %sse_max, align 16
  %152 = load <2 x i64>, <2 x i64>* %sse_idx_min, align 16
  %153 = bitcast <2 x i64> %152 to <4 x float>
  %154 = load <2 x i64>, <2 x i64>* %sse_idx_min_permute, align 16
  %155 = bitcast <2 x i64> %154 to <4 x float>
  %156 = load <4 x float>, <4 x float>* %sse_cmp_min30, align 16
  store <4 x float> %153, <4 x float>* %__V1.addr.i.123, align 16
  store <4 x float> %155, <4 x float>* %__V2.addr.i.124, align 16
  store <4 x float> %156, <4 x float>* %__M.addr.i.125, align 16
  %157 = load <4 x float>, <4 x float>* %__V1.addr.i.123, align 16
  %158 = load <4 x float>, <4 x float>* %__V2.addr.i.124, align 16
  %159 = load <4 x float>, <4 x float>* %__M.addr.i.125, align 16
  %160 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %157, <4 x float> %158, <4 x float> %159) #5
  %161 = bitcast <4 x float> %160 to <2 x i64>
  store <2 x i64> %161, <2 x i64>* %sse_idx_min, align 16
  %162 = load <2 x i64>, <2 x i64>* %sse_idx_max, align 16
  %163 = bitcast <2 x i64> %162 to <4 x float>
  %164 = load <2 x i64>, <2 x i64>* %sse_idx_max_permute, align 16
  %165 = bitcast <2 x i64> %164 to <4 x float>
  %166 = load <4 x float>, <4 x float>* %sse_cmp_max33, align 16
  store <4 x float> %163, <4 x float>* %__V1.addr.i.120, align 16
  store <4 x float> %165, <4 x float>* %__V2.addr.i.121, align 16
  store <4 x float> %166, <4 x float>* %__M.addr.i.122, align 16
  %167 = load <4 x float>, <4 x float>* %__V1.addr.i.120, align 16
  %168 = load <4 x float>, <4 x float>* %__V2.addr.i.121, align 16
  %169 = load <4 x float>, <4 x float>* %__M.addr.i.122, align 16
  %170 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %167, <4 x float> %168, <4 x float> %169) #5
  %171 = bitcast <4 x float> %170 to <2 x i64>
  store <2 x i64> %171, <2 x i64>* %sse_idx_max, align 16
  %172 = load <4 x float>, <4 x float>* %sse_min, align 16
  %173 = bitcast <4 x float> %172 to <2 x i64>
  %174 = bitcast <2 x i64> %173 to <4 x i32>
  store i32 0, i32* %__i.addr.i.114, align 4
  %175 = load i32, i32* %__i.addr.i.114, align 4
  %vecinit.i.116 = insertelement <4 x i32> undef, i32 %175, i32 0
  %176 = load i32, i32* %__i.addr.i.114, align 4
  %vecinit1.i.117 = insertelement <4 x i32> %vecinit.i.116, i32 %176, i32 1
  %177 = load i32, i32* %__i.addr.i.114, align 4
  %vecinit2.i.118 = insertelement <4 x i32> %vecinit1.i.117, i32 %177, i32 2
  %178 = load i32, i32* %__i.addr.i.114, align 4
  %vecinit3.i.119 = insertelement <4 x i32> %vecinit2.i.118, i32 %178, i32 3
  store <4 x i32> %vecinit3.i.119, <4 x i32>* %.compoundliteral.i.115
  %179 = load <4 x i32>, <4 x i32>* %.compoundliteral.i.115
  %180 = bitcast <4 x i32> %179 to <2 x i64>
  %181 = bitcast <2 x i64> %180 to <4 x i32>
  %shuffle41 = shufflevector <4 x i32> %174, <4 x i32> %181, <4 x i32> <i32 1, i32 0, i32 0, i32 0>
  %182 = bitcast <4 x i32> %shuffle41 to <2 x i64>
  store <2 x i64> %182, <2 x i64>* %tmp39
  %183 = load <2 x i64>, <2 x i64>* %tmp39
  %184 = bitcast <2 x i64> %183 to <4 x float>
  store <4 x float> %184, <4 x float>* %sse_min_permute, align 16
  %185 = load <4 x float>, <4 x float>* %sse_max, align 16
  %186 = bitcast <4 x float> %185 to <2 x i64>
  %187 = bitcast <2 x i64> %186 to <4 x i32>
  store i32 0, i32* %__i.addr.i.108, align 4
  %188 = load i32, i32* %__i.addr.i.108, align 4
  %vecinit.i.110 = insertelement <4 x i32> undef, i32 %188, i32 0
  %189 = load i32, i32* %__i.addr.i.108, align 4
  %vecinit1.i.111 = insertelement <4 x i32> %vecinit.i.110, i32 %189, i32 1
  %190 = load i32, i32* %__i.addr.i.108, align 4
  %vecinit2.i.112 = insertelement <4 x i32> %vecinit1.i.111, i32 %190, i32 2
  %191 = load i32, i32* %__i.addr.i.108, align 4
  %vecinit3.i.113 = insertelement <4 x i32> %vecinit2.i.112, i32 %191, i32 3
  store <4 x i32> %vecinit3.i.113, <4 x i32>* %.compoundliteral.i.109
  %192 = load <4 x i32>, <4 x i32>* %.compoundliteral.i.109
  %193 = bitcast <4 x i32> %192 to <2 x i64>
  %194 = bitcast <2 x i64> %193 to <4 x i32>
  %shuffle44 = shufflevector <4 x i32> %187, <4 x i32> %194, <4 x i32> <i32 1, i32 0, i32 0, i32 0>
  %195 = bitcast <4 x i32> %shuffle44 to <2 x i64>
  store <2 x i64> %195, <2 x i64>* %tmp42
  %196 = load <2 x i64>, <2 x i64>* %tmp42
  %197 = bitcast <2 x i64> %196 to <4 x float>
  store <4 x float> %197, <4 x float>* %sse_max_permute, align 16
  %198 = load <2 x i64>, <2 x i64>* %sse_idx_min, align 16
  %199 = bitcast <2 x i64> %198 to <4 x i32>
  store i32 0, i32* %__i.addr.i.102, align 4
  %200 = load i32, i32* %__i.addr.i.102, align 4
  %vecinit.i.104 = insertelement <4 x i32> undef, i32 %200, i32 0
  %201 = load i32, i32* %__i.addr.i.102, align 4
  %vecinit1.i.105 = insertelement <4 x i32> %vecinit.i.104, i32 %201, i32 1
  %202 = load i32, i32* %__i.addr.i.102, align 4
  %vecinit2.i.106 = insertelement <4 x i32> %vecinit1.i.105, i32 %202, i32 2
  %203 = load i32, i32* %__i.addr.i.102, align 4
  %vecinit3.i.107 = insertelement <4 x i32> %vecinit2.i.106, i32 %203, i32 3
  store <4 x i32> %vecinit3.i.107, <4 x i32>* %.compoundliteral.i.103
  %204 = load <4 x i32>, <4 x i32>* %.compoundliteral.i.103
  %205 = bitcast <4 x i32> %204 to <2 x i64>
  %206 = bitcast <2 x i64> %205 to <4 x i32>
  %shuffle47 = shufflevector <4 x i32> %199, <4 x i32> %206, <4 x i32> <i32 1, i32 0, i32 0, i32 0>
  %207 = bitcast <4 x i32> %shuffle47 to <2 x i64>
  store <2 x i64> %207, <2 x i64>* %tmp45
  %208 = load <2 x i64>, <2 x i64>* %tmp45
  store <2 x i64> %208, <2 x i64>* %sse_idx_min_permute, align 16
  %209 = load <2 x i64>, <2 x i64>* %sse_idx_max, align 16
  %210 = bitcast <2 x i64> %209 to <4 x i32>
  store i32 0, i32* %__i.addr.i, align 4
  %211 = load i32, i32* %__i.addr.i, align 4
  %vecinit.i = insertelement <4 x i32> undef, i32 %211, i32 0
  %212 = load i32, i32* %__i.addr.i, align 4
  %vecinit1.i = insertelement <4 x i32> %vecinit.i, i32 %212, i32 1
  %213 = load i32, i32* %__i.addr.i, align 4
  %vecinit2.i = insertelement <4 x i32> %vecinit1.i, i32 %213, i32 2
  %214 = load i32, i32* %__i.addr.i, align 4
  %vecinit3.i = insertelement <4 x i32> %vecinit2.i, i32 %214, i32 3
  store <4 x i32> %vecinit3.i, <4 x i32>* %.compoundliteral.i.101
  %215 = load <4 x i32>, <4 x i32>* %.compoundliteral.i.101
  %216 = bitcast <4 x i32> %215 to <2 x i64>
  %217 = bitcast <2 x i64> %216 to <4 x i32>
  %shuffle50 = shufflevector <4 x i32> %210, <4 x i32> %217, <4 x i32> <i32 1, i32 0, i32 0, i32 0>
  %218 = bitcast <4 x i32> %shuffle50 to <2 x i64>
  store <2 x i64> %218, <2 x i64>* %tmp48
  %219 = load <2 x i64>, <2 x i64>* %tmp48
  store <2 x i64> %219, <2 x i64>* %sse_idx_max_permute, align 16
  %220 = load <4 x float>, <4 x float>* %sse_min_permute, align 16
  %221 = load <4 x float>, <4 x float>* %sse_min, align 16
  store <4 x float> %220, <4 x float>* %__a.addr.i.98, align 16
  store <4 x float> %221, <4 x float>* %__b.addr.i.99, align 16
  %222 = load <4 x float>, <4 x float>* %__a.addr.i.98, align 16
  %223 = load <4 x float>, <4 x float>* %__b.addr.i.99, align 16
  %cmpps.i.100 = call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %222, <4 x float> %223, i8 1) #5
  store <4 x float> %cmpps.i.100, <4 x float>* %sse_cmp_min30, align 16
  %224 = load <4 x float>, <4 x float>* %sse_max_permute, align 16
  %225 = load <4 x float>, <4 x float>* %sse_max, align 16
  store <4 x float> %224, <4 x float>* %__a.addr.i.97, align 16
  store <4 x float> %225, <4 x float>* %__b.addr.i, align 16
  %226 = load <4 x float>, <4 x float>* %__b.addr.i, align 16
  %227 = load <4 x float>, <4 x float>* %__a.addr.i.97, align 16
  %cmpps.i = call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %226, <4 x float> %227, i8 1) #5
  store <4 x float> %cmpps.i, <4 x float>* %sse_cmp_max33, align 16
  %228 = load <4 x float>, <4 x float>* %sse_min, align 16
  %229 = load <4 x float>, <4 x float>* %sse_min_permute, align 16
  %230 = load <4 x float>, <4 x float>* %sse_cmp_min30, align 16
  store <4 x float> %228, <4 x float>* %__V1.addr.i.94, align 16
  store <4 x float> %229, <4 x float>* %__V2.addr.i.95, align 16
  store <4 x float> %230, <4 x float>* %__M.addr.i.96, align 16
  %231 = load <4 x float>, <4 x float>* %__V1.addr.i.94, align 16
  %232 = load <4 x float>, <4 x float>* %__V2.addr.i.95, align 16
  %233 = load <4 x float>, <4 x float>* %__M.addr.i.96, align 16
  %234 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %231, <4 x float> %232, <4 x float> %233) #5
  store <4 x float> %234, <4 x float>* %sse_min, align 16
  %235 = load <4 x float>, <4 x float>* %sse_max, align 16
  %236 = load <4 x float>, <4 x float>* %sse_max_permute, align 16
  %237 = load <4 x float>, <4 x float>* %sse_cmp_max33, align 16
  store <4 x float> %235, <4 x float>* %__V1.addr.i.91, align 16
  store <4 x float> %236, <4 x float>* %__V2.addr.i.92, align 16
  store <4 x float> %237, <4 x float>* %__M.addr.i.93, align 16
  %238 = load <4 x float>, <4 x float>* %__V1.addr.i.91, align 16
  %239 = load <4 x float>, <4 x float>* %__V2.addr.i.92, align 16
  %240 = load <4 x float>, <4 x float>* %__M.addr.i.93, align 16
  %241 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %238, <4 x float> %239, <4 x float> %240) #5
  store <4 x float> %241, <4 x float>* %sse_max, align 16
  %242 = load <2 x i64>, <2 x i64>* %sse_idx_min, align 16
  %243 = bitcast <2 x i64> %242 to <4 x float>
  %244 = load <2 x i64>, <2 x i64>* %sse_idx_min_permute, align 16
  %245 = bitcast <2 x i64> %244 to <4 x float>
  %246 = load <4 x float>, <4 x float>* %sse_cmp_min30, align 16
  store <4 x float> %243, <4 x float>* %__V1.addr.i.88, align 16
  store <4 x float> %245, <4 x float>* %__V2.addr.i.89, align 16
  store <4 x float> %246, <4 x float>* %__M.addr.i.90, align 16
  %247 = load <4 x float>, <4 x float>* %__V1.addr.i.88, align 16
  %248 = load <4 x float>, <4 x float>* %__V2.addr.i.89, align 16
  %249 = load <4 x float>, <4 x float>* %__M.addr.i.90, align 16
  %250 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %247, <4 x float> %248, <4 x float> %249) #5
  %251 = bitcast <4 x float> %250 to <2 x i64>
  store <2 x i64> %251, <2 x i64>* %sse_idx_min, align 16
  %252 = load <2 x i64>, <2 x i64>* %sse_idx_max, align 16
  %253 = bitcast <2 x i64> %252 to <4 x float>
  %254 = load <2 x i64>, <2 x i64>* %sse_idx_max_permute, align 16
  %255 = bitcast <2 x i64> %254 to <4 x float>
  %256 = load <4 x float>, <4 x float>* %sse_cmp_max33, align 16
  store <4 x float> %253, <4 x float>* %__V1.addr.i, align 16
  store <4 x float> %255, <4 x float>* %__V2.addr.i, align 16
  store <4 x float> %256, <4 x float>* %__M.addr.i, align 16
  %257 = load <4 x float>, <4 x float>* %__V1.addr.i, align 16
  %258 = load <4 x float>, <4 x float>* %__V2.addr.i, align 16
  %259 = load <4 x float>, <4 x float>* %__M.addr.i, align 16
  %260 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %257, <4 x float> %258, <4 x float> %259) #5
  %261 = bitcast <4 x float> %260 to <2 x i64>
  store <2 x i64> %261, <2 x i64>* %sse_idx_max, align 16
  %262 = load <4 x float>, <4 x float>* %sse_min, align 16
  store float* %min, float** %__p.addr.i.84, align 8
  store <4 x float> %262, <4 x float>* %__a.addr.i.85, align 16
  %263 = load <4 x float>, <4 x float>* %__a.addr.i.85, align 16
  %vecext.i.86 = extractelement <4 x float> %263, i32 0
  %264 = load float*, float** %__p.addr.i.84, align 8
  %265 = bitcast float* %264 to %struct.__mm_store_ss_struct*
  %__u.i.87 = getelementptr inbounds %struct.__mm_store_ss_struct, %struct.__mm_store_ss_struct* %265, i32 0, i32 0
  store float %vecext.i.86, float* %__u.i.87, align 1
  %266 = load <4 x float>, <4 x float>* %sse_max, align 16
  store float* %max, float** %__p.addr.i, align 8
  store <4 x float> %266, <4 x float>* %__a.addr.i, align 16
  %267 = load <4 x float>, <4 x float>* %__a.addr.i, align 16
  %vecext.i = extractelement <4 x float> %267, i32 0
  %268 = load float*, float** %__p.addr.i, align 8
  %269 = bitcast float* %268 to %struct.__mm_store_ss_struct*
  %__u.i = getelementptr inbounds %struct.__mm_store_ss_struct, %struct.__mm_store_ss_struct* %269, i32 0, i32 0
  store float %vecext.i, float* %__u.i, align 1
  %270 = load <2 x i64>, <2 x i64>* %sse_idx_min, align 16
  %271 = bitcast <2 x i64> %270 to <4 x i32>
  store <4 x i32> %271, <4 x i32>* %__a, align 16
  %272 = load <4 x i32>, <4 x i32>* %__a, align 16
  %vecext = extractelement <4 x i32> %272, i32 0
  store i32 %vecext, i32* %tmp62
  %273 = load i32, i32* %tmp62
  store i32 %273, i32* %idx_min, align 4
  %274 = load <2 x i64>, <2 x i64>* %sse_idx_max, align 16
  %275 = bitcast <2 x i64> %274 to <4 x i32>
  store <4 x i32> %275, <4 x i32>* %__a64, align 16
  %276 = load <4 x i32>, <4 x i32>* %__a64, align 16
  %vecext66 = extractelement <4 x i32> %276, i32 0
  store i32 %vecext66, i32* %tmp65
  %277 = load i32, i32* %tmp65
  store i32 %277, i32* %idx_max, align 4
  %278 = load i32, i32* %n_sse, align 4
  store i32 %278, i32* %i68, align 4
  br label %for.cond.69

for.cond.69:                                      ; preds = %for.inc.82, %for.end
  %279 = load i32, i32* %i68, align 4
  %280 = load i32, i32* %n.addr, align 4
  %cmp70 = icmp ult i32 %279, %280
  br i1 %cmp70, label %for.body.72, label %for.end.83

for.body.72:                                      ; preds = %for.cond.69
  %281 = load i32, i32* %i68, align 4
  %idxprom74 = zext i32 %281 to i64
  %282 = load float*, float** %buf.addr, align 8
  %arrayidx75 = getelementptr inbounds float, float* %282, i64 %idxprom74
  %283 = load float, float* %arrayidx75, align 4
  store float %283, float* %v, align 4
  %284 = load float, float* %v, align 4
  %285 = load float, float* %min, align 4
  %cmp76 = fcmp olt float %284, %285
  br i1 %cmp76, label %if.then, label %if.end

if.then:                                          ; preds = %for.body.72
  %286 = load float, float* %v, align 4
  store float %286, float* %min, align 4
  %287 = load i32, i32* %i68, align 4
  store i32 %287, i32* %idx_min, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body.72
  %288 = load float, float* %v, align 4
  %289 = load float, float* %max, align 4
  %cmp78 = fcmp ogt float %288, %289
  br i1 %cmp78, label %if.then.80, label %if.end.81

if.then.80:                                       ; preds = %if.end
  %290 = load float, float* %v, align 4
  store float %290, float* %max, align 4
  %291 = load i32, i32* %i68, align 4
  store i32 %291, i32* %idx_max, align 4
  br label %if.end.81

if.end.81:                                        ; preds = %if.then.80, %if.end
  br label %for.inc.82

for.inc.82:                                       ; preds = %if.end.81
  %292 = load i32, i32* %i68, align 4
  %inc = add i32 %292, 1
  store i32 %inc, i32* %i68, align 4
  br label %for.cond.69

for.end.83:                                       ; preds = %for.cond.69
  %293 = load i32, i32* %idx_min, align 4
  %294 = load i32*, i32** %idx_min_.addr, align 8
  store i32 %293, i32* %294, align 4
  %295 = load float, float* %min, align 4
  %296 = load float*, float** %min_.addr, align 8
  store float %295, float* %296, align 4
  %297 = load i32, i32* %idx_max, align 4
  %298 = load i32*, i32** %idx_max_.addr, align 8
  store i32 %297, i32* %298, align 4
  %299 = load float, float* %max, align 4
  %300 = load float*, float** %max_.addr, align 8
  store float %299, float* %300, align 4
  ret void
}

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %n = alloca i32, align 4
  %buf = alloca float*, align 8
  %i = alloca i32, align 4
  %min = alloca float, align 4
  %max = alloca float, align 4
  %min_idx = alloca i32, align 4
  %max_idx = alloca i32, align 4
  %__bench_start_org = alloca double, align 8
  %__bench_end_org = alloca double, align 8
  %time = alloca double, align 8
  %size_in_mb = alloca double, align 8
  %size_out_mb = alloca double, align 8
  %bw_in = alloca double, align 8
  %bw_out = alloca double, align 8
  %min27 = alloca float, align 4
  %max28 = alloca float, align 4
  %min_idx29 = alloca i32, align 4
  %max_idx30 = alloca i32, align 4
  %__bench_start_sse = alloca double, align 8
  %__bench_end_sse = alloca double, align 8
  %time33 = alloca double, align 8
  %size_in_mb35 = alloca double, align 8
  %size_out_mb40 = alloca double, align 8
  %bw_in41 = alloca double, align 8
  %bw_out43 = alloca double, align 8
  %min51 = alloca float, align 4
  %max52 = alloca float, align 4
  %min_idx53 = alloca i32, align 4
  %max_idx54 = alloca i32, align 4
  %__bench_start_sse55 = alloca double, align 8
  %__bench_end_sse57 = alloca double, align 8
  %time59 = alloca double, align 8
  %size_in_mb61 = alloca double, align 8
  %size_out_mb66 = alloca double, align 8
  %bw_in67 = alloca double, align 8
  %bw_out69 = alloca double, align 8
  store i32 0, i32* %retval
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 8
  %0 = load i32, i32* %argc.addr, align 4
  %cmp = icmp slt i32 %0, 2
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %1 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %2 = load i8**, i8*** %argv.addr, align 8
  %arrayidx = getelementptr inbounds i8*, i8** %2, i64 0
  %3 = load i8*, i8** %arrayidx, align 8
  %call = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %1, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i32 0, i32 0), i8* %3)
  store i32 1, i32* %retval
  br label %return

if.end:                                           ; preds = %entry
  %4 = load i8**, i8*** %argv.addr, align 8
  %arrayidx1 = getelementptr inbounds i8*, i8** %4, i64 1
  %5 = load i8*, i8** %arrayidx1, align 8
  %call2 = call i64 @atol(i8* %5) #6
  %conv = trunc i64 %call2 to i32
  store i32 %conv, i32* %n, align 4
  %6 = bitcast float** %buf to i8**
  %7 = load i32, i32* %n, align 4
  %conv3 = zext i32 %7 to i64
  %mul = mul i64 4, %conv3
  %call4 = call i32 @posix_memalign(i8** %6, i64 16, i64 %mul) #5
  %8 = load i32, i32* %n, align 4
  %call5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([44 x i8], [44 x i8]* @.str.1, i32 0, i32 0), i32 %8)
  %call6 = call i64 @time(i64* null) #5
  %conv7 = trunc i64 %call6 to i32
  call void @srand(i32 %conv7) #5
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end
  %9 = load i32, i32* %i, align 4
  %10 = load i32, i32* %n, align 4
  %cmp8 = icmp ult i32 %9, %10
  br i1 %cmp8, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %call10 = call i32 @rand() #5
  %conv11 = sitofp i32 %call10 to float
  %11 = load i32, i32* %i, align 4
  %idxprom = zext i32 %11 to i64
  %12 = load float*, float** %buf, align 8
  %arrayidx12 = getelementptr inbounds float, float* %12, i64 %idxprom
  store float %conv11, float* %arrayidx12, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %13 = load i32, i32* %i, align 4
  %inc = add i32 %13, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %call13 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  %call14 = call double @get_current_timestamp()
  store double %call14, double* %__bench_start_org, align 8
  %14 = load i32, i32* %n, align 4
  %15 = load float*, float** %buf, align 8
  call void @minmax(i32 %14, float* %15, i32* %min_idx, i32* %max_idx, float* %min, float* %max)
  %call15 = call double @get_current_timestamp()
  store double %call15, double* %__bench_end_org, align 8
  %16 = load double, double* %__bench_end_org, align 8
  %17 = load double, double* %__bench_start_org, align 8
  %sub = fsub double %16, %17
  store double %sub, double* %time, align 8
  %18 = load i32, i32* %n, align 4
  %conv16 = zext i32 %18 to i64
  %mul17 = mul i64 4, %conv16
  %conv18 = uitofp i64 %mul17 to double
  %div = fdiv double %conv18, 1.048576e+06
  store double %div, double* %size_in_mb, align 8
  store double 0x3EB0000000000000, double* %size_out_mb, align 8
  %19 = load double, double* %size_in_mb, align 8
  %20 = load double, double* %time, align 8
  %div19 = fdiv double %19, %20
  store double %div19, double* %bw_in, align 8
  %21 = load double, double* %size_out_mb, align 8
  %22 = load double, double* %time, align 8
  %div20 = fdiv double %21, %22
  store double %div20, double* %bw_out, align 8
  %23 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %24 = load double, double* %time, align 8
  %mul21 = fmul double %24, 1.000000e+03
  %25 = load double, double* %size_in_mb, align 8
  %26 = load double, double* %bw_in, align 8
  %27 = load double, double* %size_out_mb, align 8
  %28 = load double, double* %bw_out, align 8
  %call22 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([107 x i8], [107 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0), double %mul21, i64 4, double %25, double %26, i64 1, double %27, double %28)
  %29 = load float, float* %min, align 4
  %conv23 = fpext float %29 to double
  %30 = load i32, i32* %min_idx, align 4
  %call24 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.5, i32 0, i32 0), double %conv23, i32 %30)
  %31 = load float, float* %max, align 4
  %conv25 = fpext float %31 to double
  %32 = load i32, i32* %max_idx, align 4
  %call26 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.6, i32 0, i32 0), double %conv25, i32 %32)
  %call31 = call double @get_current_timestamp()
  store double %call31, double* %__bench_start_sse, align 8
  %33 = load i32, i32* %n, align 4
  %34 = load float*, float** %buf, align 8
  call void @minmax_vec(i32 %33, float* %34, i32* %min_idx29, i32* %max_idx30, float* %min27, float* %max28)
  %call32 = call double @get_current_timestamp()
  store double %call32, double* %__bench_end_sse, align 8
  %35 = load double, double* %__bench_end_sse, align 8
  %36 = load double, double* %__bench_start_sse, align 8
  %sub34 = fsub double %35, %36
  store double %sub34, double* %time33, align 8
  %37 = load i32, i32* %n, align 4
  %conv36 = zext i32 %37 to i64
  %mul37 = mul i64 4, %conv36
  %conv38 = uitofp i64 %mul37 to double
  %div39 = fdiv double %conv38, 1.048576e+06
  store double %div39, double* %size_in_mb35, align 8
  store double 0x3EB0000000000000, double* %size_out_mb40, align 8
  %38 = load double, double* %size_in_mb35, align 8
  %39 = load double, double* %time33, align 8
  %div42 = fdiv double %38, %39
  store double %div42, double* %bw_in41, align 8
  %40 = load double, double* %size_out_mb40, align 8
  %41 = load double, double* %time33, align 8
  %div44 = fdiv double %40, %41
  store double %div44, double* %bw_out43, align 8
  %42 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %43 = load double, double* %time33, align 8
  %mul45 = fmul double %43, 1.000000e+03
  %44 = load double, double* %size_in_mb35, align 8
  %45 = load double, double* %bw_in41, align 8
  %46 = load double, double* %size_out_mb40, align 8
  %47 = load double, double* %bw_out43, align 8
  %call46 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %42, i8* getelementptr inbounds ([107 x i8], [107 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0), double %mul45, i64 4, double %44, double %45, i64 1, double %46, double %47)
  %48 = load float, float* %min27, align 4
  %conv47 = fpext float %48 to double
  %49 = load i32, i32* %min_idx29, align 4
  %call48 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.5, i32 0, i32 0), double %conv47, i32 %49)
  %50 = load float, float* %max28, align 4
  %conv49 = fpext float %50 to double
  %51 = load i32, i32* %max_idx30, align 4
  %call50 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.6, i32 0, i32 0), double %conv49, i32 %51)
  %call56 = call double @get_current_timestamp()
  store double %call56, double* %__bench_start_sse55, align 8
  %52 = load i32, i32* %n, align 4
  %53 = load float*, float** %buf, align 8
  call void @minmax_vec2(i32 %52, float* %53, i32* %min_idx53, i32* %max_idx54, float* %min51, float* %max52)
  %call58 = call double @get_current_timestamp()
  store double %call58, double* %__bench_end_sse57, align 8
  %54 = load double, double* %__bench_end_sse57, align 8
  %55 = load double, double* %__bench_start_sse55, align 8
  %sub60 = fsub double %54, %55
  store double %sub60, double* %time59, align 8
  %56 = load i32, i32* %n, align 4
  %conv62 = zext i32 %56 to i64
  %mul63 = mul i64 4, %conv62
  %conv64 = uitofp i64 %mul63 to double
  %div65 = fdiv double %conv64, 1.048576e+06
  store double %div65, double* %size_in_mb61, align 8
  store double 0x3EB0000000000000, double* %size_out_mb66, align 8
  %57 = load double, double* %size_in_mb61, align 8
  %58 = load double, double* %time59, align 8
  %div68 = fdiv double %57, %58
  store double %div68, double* %bw_in67, align 8
  %59 = load double, double* %size_out_mb66, align 8
  %60 = load double, double* %time59, align 8
  %div70 = fdiv double %59, %60
  store double %div70, double* %bw_out69, align 8
  %61 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %62 = load double, double* %time59, align 8
  %mul71 = fmul double %62, 1.000000e+03
  %63 = load double, double* %size_in_mb61, align 8
  %64 = load double, double* %bw_in67, align 8
  %65 = load double, double* %size_out_mb66, align 8
  %66 = load double, double* %bw_out69, align 8
  %call72 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %61, i8* getelementptr inbounds ([107 x i8], [107 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.8, i32 0, i32 0), double %mul71, i64 4, double %63, double %64, i64 1, double %65, double %66)
  %67 = load float, float* %min51, align 4
  %conv73 = fpext float %67 to double
  %68 = load i32, i32* %min_idx53, align 4
  %call74 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.5, i32 0, i32 0), double %conv73, i32 %68)
  %69 = load float, float* %max52, align 4
  %conv75 = fpext float %69 to double
  %70 = load i32, i32* %max_idx54, align 4
  %call76 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.6, i32 0, i32 0), double %conv75, i32 %70)
  store i32 0, i32* %retval
  br label %return

return:                                           ; preds = %for.end, %if.then
  %71 = load i32, i32* %retval
  ret i32 %71
}

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...) #2

; Function Attrs: nounwind readonly
declare i64 @atol(i8*) #3

; Function Attrs: nounwind
declare i32 @posix_memalign(i8**, i64, i64) #1

declare i32 @printf(i8*, ...) #2

; Function Attrs: nounwind
declare void @srand(i32) #1

; Function Attrs: nounwind
declare i64 @time(i64*) #1

; Function Attrs: nounwind
declare i32 @rand() #1

; Function Attrs: nounwind readnone
declare <4 x float> @llvm.x86.sse.cmp.ps(<4 x float>, <4 x float>, i8) #4

; Function Attrs: nounwind readnone
declare <4 x float> @llvm.x86.sse41.blendvps(<4 x float>, <4 x float>, <4 x float>) #4

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+ssse3,+sse3,+sse,+sse2,+sse4.1,+sse4.2,+popcnt" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+ssse3,+sse3,+sse,+sse2,+sse4.1,+sse4.2,+popcnt" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+ssse3,+sse3,+sse,+sse2,+sse4.1,+sse4.2,+popcnt" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind readonly "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+ssse3,+sse3,+sse,+sse2,+sse4.1,+sse4.2,+popcnt" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind readnone }
attributes #5 = { nounwind }
attributes #6 = { nounwind readonly }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (http://llvm.org/git/clang.git f860d72ec36b6b7b36e6128297eb143090ca46a3) (http://llvm.org/git/llvm.git c8d166a4373812212ed489c41760bac3b8c043ff)"}
