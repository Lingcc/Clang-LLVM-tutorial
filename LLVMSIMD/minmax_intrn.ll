; ModuleID = 'minmax_intrn.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct.timeval = type { i64, i64 }
%struct.timezone = type { i32, i32 }

@stderr = external global %struct._IO_FILE*, align 8
@.str = private unnamed_addr constant [12 x i8] c"Usage: %s n\00", align 1
@.str.1 = private unnamed_addr constant [44 x i8] c"Initialize a random buffer of %u floats...\0A\00", align 1
@.str.3 = private unnamed_addr constant [107 x i8] c"%s: in %0.5f ms. Input (#/size/BW): %lu/%0.5f MB/%0.5f MB/s | Output (#/size/BW): %lu/%0.5f MB/%0.5f MB/s\0A\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"org\00", align 1
@.str.5 = private unnamed_addr constant [23 x i8] c"Min (idx): %0.4f (%u)\0A\00", align 1
@.str.6 = private unnamed_addr constant [23 x i8] c"Max (idx): %0.4f (%u)\0A\00", align 1
@.str.7 = private unnamed_addr constant [4 x i8] c"sse\00", align 1
@.str.8 = private unnamed_addr constant [5 x i8] c"sse2\00", align 1
@str = private unnamed_addr constant [6 x i8] c"Done!\00"

; Function Attrs: nounwind uwtable
define double @get_current_timestamp() #0 {
entry:
  %curt = alloca %struct.timeval, align 8
  %0 = bitcast %struct.timeval* %curt to i8*
  call void @llvm.lifetime.start(i64 16, i8* %0) #1
  %call = call i32 @gettimeofday(%struct.timeval* %curt, %struct.timezone* null) #1
  %tv_sec = getelementptr inbounds %struct.timeval, %struct.timeval* %curt, i64 0, i32 0
  %1 = load i64, i64* %tv_sec, align 8, !tbaa !1
  %conv = sitofp i64 %1 to double
  %tv_usec = getelementptr inbounds %struct.timeval, %struct.timeval* %curt, i64 0, i32 1
  %2 = load i64, i64* %tv_usec, align 8, !tbaa !6
  %conv1 = sitofp i64 %2 to double
  %div = fdiv double %conv1, 1.000000e+06
  %add = fadd double %conv, %div
  call void @llvm.lifetime.end(i64 16, i8* %0) #1
  ret double %add
}

; Function Attrs: nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #1

; Function Attrs: nounwind
declare i32 @gettimeofday(%struct.timeval* nocapture, %struct.timezone* nocapture) #2

; Function Attrs: nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define void @minmax(i32 %n, float* nocapture readonly %buf, i32* nocapture %idx_min_, i32* nocapture %idx_max_, float* nocapture %min_, float* nocapture %max_) #0 {
entry:
  %cmp.24 = icmp eq i32 %n, 0
  br i1 %cmp.24, label %for.end, label %for.body.preheader

for.body.preheader:                               ; preds = %entry
  %xtraiter = and i32 %n, 1
  %lcmp.mod = icmp eq i32 %xtraiter, 0
  br i1 %lcmp.mod, label %for.body.preheader.split, label %for.body.prol

for.body.prol:                                    ; preds = %for.body.preheader
  %0 = load float, float* %buf, align 4, !tbaa !7
  %cmp1.prol = fcmp olt float %0, 0x47EFFFFFE0000000
  %min.1.prol = select i1 %cmp1.prol, float %0, float 0x47EFFFFFE0000000
  %cmp2.prol = fcmp ogt float %0, 0x3810000000000000
  %max.1.prol = select i1 %cmp2.prol, float %0, float 0x3810000000000000
  br label %for.body.preheader.split

for.body.preheader.split:                         ; preds = %for.body.preheader, %for.body.prol
  %max.1.lcssa.unr = phi float [ 0.000000e+00, %for.body.preheader ], [ %max.1.prol, %for.body.prol ]
  %min.1.lcssa.unr = phi float [ 0.000000e+00, %for.body.preheader ], [ %min.1.prol, %for.body.prol ]
  %indvars.iv.unr = phi i64 [ 0, %for.body.preheader ], [ 1, %for.body.prol ]
  %max.027.unr = phi float [ 0x3810000000000000, %for.body.preheader ], [ %max.1.prol, %for.body.prol ]
  %min.026.unr = phi float [ 0x47EFFFFFE0000000, %for.body.preheader ], [ %min.1.prol, %for.body.prol ]
  %1 = icmp eq i32 %n, 1
  br i1 %1, label %for.cond.for.end_crit_edge, label %for.body.preheader.split.split

for.body.preheader.split.split:                   ; preds = %for.body.preheader.split
  br label %for.body

for.body:                                         ; preds = %for.body, %for.body.preheader.split.split
  %indvars.iv = phi i64 [ %indvars.iv.unr, %for.body.preheader.split.split ], [ %indvars.iv.next.1, %for.body ]
  %idx_min.029 = phi i64 [ 0, %for.body.preheader.split.split ], [ %idx_min.1.1, %for.body ]
  %max.027 = phi float [ %max.027.unr, %for.body.preheader.split.split ], [ %max.1.1, %for.body ]
  %min.026 = phi float [ %min.026.unr, %for.body.preheader.split.split ], [ %min.1.1, %for.body ]
  %idx_max.025 = phi i64 [ 0, %for.body.preheader.split.split ], [ %idx_max.1.1, %for.body ]
  %arrayidx = getelementptr inbounds float, float* %buf, i64 %indvars.iv
  %2 = load float, float* %arrayidx, align 4, !tbaa !7
  %cmp1 = fcmp olt float %2, %min.026
  %min.1 = select i1 %cmp1, float %2, float %min.026
  %idx_min.1 = select i1 %cmp1, i64 %indvars.iv, i64 %idx_min.029
  %cmp2 = fcmp ogt float %2, %max.027
  %idx_max.1 = select i1 %cmp2, i64 %indvars.iv, i64 %idx_max.025
  %max.1 = select i1 %cmp2, float %2, float %max.027
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %arrayidx.1 = getelementptr inbounds float, float* %buf, i64 %indvars.iv.next
  %3 = load float, float* %arrayidx.1, align 4, !tbaa !7
  %cmp1.1 = fcmp olt float %3, %min.1
  %min.1.1 = select i1 %cmp1.1, float %3, float %min.1
  %idx_min.1.1 = select i1 %cmp1.1, i64 %indvars.iv.next, i64 %idx_min.1
  %cmp2.1 = fcmp ogt float %3, %max.1
  %idx_max.1.1 = select i1 %cmp2.1, i64 %indvars.iv.next, i64 %idx_max.1
  %max.1.1 = select i1 %cmp2.1, float %3, float %max.1
  %indvars.iv.next.1 = add nsw i64 %indvars.iv, 2
  %lftr.wideiv.1 = trunc i64 %indvars.iv.next.1 to i32
  %exitcond.1 = icmp eq i32 %lftr.wideiv.1, %n
  br i1 %exitcond.1, label %for.cond.for.end_crit_edge.unr-lcssa, label %for.body

for.cond.for.end_crit_edge.unr-lcssa:             ; preds = %for.body
  %max.1.1.lcssa = phi float [ %max.1.1, %for.body ]
  %idx_max.1.1.lcssa = phi i64 [ %idx_max.1.1, %for.body ]
  %idx_min.1.1.lcssa = phi i64 [ %idx_min.1.1, %for.body ]
  %min.1.1.lcssa = phi float [ %min.1.1, %for.body ]
  %phitmp34 = trunc i64 %idx_min.1.1.lcssa to i32
  %phitmp = trunc i64 %idx_max.1.1.lcssa to i32
  br label %for.cond.for.end_crit_edge

for.cond.for.end_crit_edge:                       ; preds = %for.body.preheader.split, %for.cond.for.end_crit_edge.unr-lcssa
  %max.1.lcssa = phi float [ %max.1.lcssa.unr, %for.body.preheader.split ], [ %max.1.1.lcssa, %for.cond.for.end_crit_edge.unr-lcssa ]
  %idx_max.1.lcssa = phi i32 [ 0, %for.body.preheader.split ], [ %phitmp, %for.cond.for.end_crit_edge.unr-lcssa ]
  %idx_min.1.lcssa = phi i32 [ 0, %for.body.preheader.split ], [ %phitmp34, %for.cond.for.end_crit_edge.unr-lcssa ]
  %min.1.lcssa = phi float [ %min.1.lcssa.unr, %for.body.preheader.split ], [ %min.1.1.lcssa, %for.cond.for.end_crit_edge.unr-lcssa ]
  br label %for.end

for.end:                                          ; preds = %entry, %for.cond.for.end_crit_edge
  %idx_min.0.lcssa = phi i32 [ %idx_min.1.lcssa, %for.cond.for.end_crit_edge ], [ 0, %entry ]
  %max.0.lcssa = phi float [ %max.1.lcssa, %for.cond.for.end_crit_edge ], [ 0x3810000000000000, %entry ]
  %min.0.lcssa = phi float [ %min.1.lcssa, %for.cond.for.end_crit_edge ], [ 0x47EFFFFFE0000000, %entry ]
  %idx_max.0.lcssa = phi i32 [ %idx_max.1.lcssa, %for.cond.for.end_crit_edge ], [ 0, %entry ]
  store i32 %idx_min.0.lcssa, i32* %idx_min_, align 4, !tbaa !9
  store float %min.0.lcssa, float* %min_, align 4, !tbaa !7
  store i32 %idx_max.0.lcssa, i32* %idx_max_, align 4, !tbaa !9
  store float %max.0.lcssa, float* %max_, align 4, !tbaa !7
  ret void
}

; Function Attrs: nounwind uwtable
define void @minmax_vec(i32 %n, float* nocapture readonly %buf, i32* nocapture %idx_min_, i32* nocapture %idx_max_, float* nocapture %min_, float* nocapture %max_) #0 {
entry:
  %and = and i32 %n, -4
  %cmp.154 = icmp eq i32 %and, 0
  br i1 %cmp.154, label %for.cond.cleanup, label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %entry
  %0 = zext i32 %and to i64
  br label %for.body

for.cond.for.cond.cleanup_crit_edge:              ; preds = %for.body
  %.lcssa209 = phi <4 x float> [ %10, %for.body ]
  %.lcssa208 = phi <4 x float> [ %7, %for.body ]
  %.lcssa207 = phi <4 x float> [ %4, %for.body ]
  %.lcssa = phi <4 x float> [ %3, %for.body ]
  %phitmp = bitcast <4 x float> %.lcssa208 to <4 x i32>
  %phitmp165 = bitcast <4 x float> %.lcssa209 to <4 x i32>
  %phitmp183 = extractelement <4 x float> %.lcssa, i32 0
  %phitmp191 = extractelement <4 x float> %.lcssa207, i32 0
  %phitmp192 = extractelement <4 x float> %.lcssa, i32 1
  %phitmp193 = extractelement <4 x float> %.lcssa207, i32 1
  %phitmp194 = extractelement <4 x float> %.lcssa, i32 2
  %phitmp195 = extractelement <4 x float> %.lcssa207, i32 2
  %phitmp196 = extractelement <4 x float> %.lcssa, i32 3
  %phitmp197 = extractelement <4 x float> %.lcssa207, i32 3
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %entry, %for.cond.for.cond.cleanup_crit_edge
  %sse_idx_min.0.lcssa = phi <4 x i32> [ %phitmp, %for.cond.for.cond.cleanup_crit_edge ], [ zeroinitializer, %entry ]
  %sse_idx_max.0.lcssa = phi <4 x i32> [ %phitmp165, %for.cond.for.cond.cleanup_crit_edge ], [ zeroinitializer, %entry ]
  %sse_min.0.lcssa.off0 = phi float [ %phitmp183, %for.cond.for.cond.cleanup_crit_edge ], [ 0x47EFFFFFE0000000, %entry ]
  %sse_min.0.lcssa.off32 = phi float [ %phitmp192, %for.cond.for.cond.cleanup_crit_edge ], [ 0x47EFFFFFE0000000, %entry ]
  %sse_min.0.lcssa.off64 = phi float [ %phitmp194, %for.cond.for.cond.cleanup_crit_edge ], [ 0x47EFFFFFE0000000, %entry ]
  %sse_min.0.lcssa.off96 = phi float [ %phitmp196, %for.cond.for.cond.cleanup_crit_edge ], [ 0x47EFFFFFE0000000, %entry ]
  %sse_max.0.lcssa.off0 = phi float [ %phitmp191, %for.cond.for.cond.cleanup_crit_edge ], [ 0x3810000000000000, %entry ]
  %sse_max.0.lcssa.off32 = phi float [ %phitmp193, %for.cond.for.cond.cleanup_crit_edge ], [ 0x3810000000000000, %entry ]
  %sse_max.0.lcssa.off64 = phi float [ %phitmp195, %for.cond.for.cond.cleanup_crit_edge ], [ 0x3810000000000000, %entry ]
  %sse_max.0.lcssa.off96 = phi float [ %phitmp197, %for.cond.for.cond.cleanup_crit_edge ], [ 0x3810000000000000, %entry ]
  %vecext = extractelement <4 x i32> %sse_idx_min.0.lcssa, i32 0
  %vecext23 = extractelement <4 x i32> %sse_idx_max.0.lcssa, i32 0
  %cmp34 = fcmp olt float %sse_min.0.lcssa.off32, %sse_min.0.lcssa.off0
  %vecext40 = extractelement <4 x i32> %sse_idx_min.0.lcssa, i32 1
  %idx_min.1 = select i1 %cmp34, i32 %vecext40, i32 %vecext
  %min.1 = select i1 %cmp34, float %sse_min.0.lcssa.off32, float %sse_min.0.lcssa.off0
  %cmp43 = fcmp ogt float %sse_max.0.lcssa.off32, %sse_max.0.lcssa.off0
  %vecext50 = extractelement <4 x i32> %sse_idx_max.0.lcssa, i32 1
  %max.1 = select i1 %cmp43, float %sse_max.0.lcssa.off32, float %sse_max.0.lcssa.off0
  %idx_max.1 = select i1 %cmp43, i32 %vecext50, i32 %vecext23
  %cmp34.1 = fcmp olt float %sse_min.0.lcssa.off64, %min.1
  %vecext40.1 = extractelement <4 x i32> %sse_idx_min.0.lcssa, i32 2
  %idx_min.1.1 = select i1 %cmp34.1, i32 %vecext40.1, i32 %idx_min.1
  %min.1.1 = select i1 %cmp34.1, float %sse_min.0.lcssa.off64, float %min.1
  %cmp43.1 = fcmp ogt float %sse_max.0.lcssa.off64, %max.1
  %vecext50.1 = extractelement <4 x i32> %sse_idx_max.0.lcssa, i32 2
  %max.1.1 = select i1 %cmp43.1, float %sse_max.0.lcssa.off64, float %max.1
  %idx_max.1.1 = select i1 %cmp43.1, i32 %vecext50.1, i32 %idx_max.1
  %cmp34.2 = fcmp olt float %sse_min.0.lcssa.off96, %min.1.1
  %vecext40.2 = extractelement <4 x i32> %sse_idx_min.0.lcssa, i32 3
  %idx_min.1.2 = select i1 %cmp34.2, i32 %vecext40.2, i32 %idx_min.1.1
  %min.1.2 = select i1 %cmp34.2, float %sse_min.0.lcssa.off96, float %min.1.1
  %cmp43.2 = fcmp ogt float %sse_max.0.lcssa.off96, %max.1.1
  %vecext50.2 = extractelement <4 x i32> %sse_idx_max.0.lcssa, i32 3
  %max.1.2 = select i1 %cmp43.2, float %sse_max.0.lcssa.off96, float %max.1.1
  %idx_max.1.2 = select i1 %cmp43.2, i32 %vecext50.2, i32 %idx_max.1.1
  %cmp57.140 = icmp ult i32 %and, %n
  br i1 %cmp57.140, label %for.body.60.lr.ph, label %for.cond.cleanup.59

for.body:                                         ; preds = %for.body.lr.ph, %for.body
  %indvars.iv173 = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next174, %for.body ]
  %sse_idx_min.0160 = phi <2 x i64> [ zeroinitializer, %for.body.lr.ph ], [ %8, %for.body ]
  %sse_idx_max.0159 = phi <2 x i64> [ zeroinitializer, %for.body.lr.ph ], [ %11, %for.body ]
  %sse_min.0158 = phi <4 x float> [ <float 0x47EFFFFFE0000000, float 0x47EFFFFFE0000000, float 0x47EFFFFFE0000000, float 0x47EFFFFFE0000000>, %for.body.lr.ph ], [ %3, %for.body ]
  %sse_max.0157 = phi <4 x float> [ <float 0x3810000000000000, float 0x3810000000000000, float 0x3810000000000000, float 0x3810000000000000>, %for.body.lr.ph ], [ %4, %for.body ]
  %sse_idx.0156 = phi <2 x i64> [ <i64 4294967296, i64 12884901890>, %for.body.lr.ph ], [ %13, %for.body ]
  %arrayidx = getelementptr inbounds float, float* %buf, i64 %indvars.iv173
  %1 = bitcast float* %arrayidx to <4 x float>*
  %2 = load <4 x float>, <4 x float>* %1, align 16, !tbaa !11
  %cmpps.i.138 = tail call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %2, <4 x float> %sse_min.0158, i8 1) #1
  %cmpps.i = tail call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %sse_max.0157, <4 x float> %2, i8 1) #1
  %3 = tail call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %sse_min.0158, <4 x float> %2, <4 x float> %cmpps.i.138) #1
  %4 = tail call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %sse_max.0157, <4 x float> %2, <4 x float> %cmpps.i) #1
  %5 = bitcast <2 x i64> %sse_idx_min.0160 to <4 x float>
  %6 = bitcast <2 x i64> %sse_idx.0156 to <4 x float>
  %7 = tail call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %5, <4 x float> %6, <4 x float> %cmpps.i.138) #1
  %8 = bitcast <4 x float> %7 to <2 x i64>
  %9 = bitcast <2 x i64> %sse_idx_max.0159 to <4 x float>
  %10 = tail call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %9, <4 x float> %6, <4 x float> %cmpps.i) #1
  %11 = bitcast <4 x float> %10 to <2 x i64>
  %12 = bitcast <2 x i64> %sse_idx.0156 to <4 x i32>
  %add.i = add <4 x i32> %12, <i32 4, i32 4, i32 4, i32 4>
  %13 = bitcast <4 x i32> %add.i to <2 x i64>
  %indvars.iv.next174 = add nuw nsw i64 %indvars.iv173, 4
  %cmp = icmp ult i64 %indvars.iv.next174, %0
  br i1 %cmp, label %for.body, label %for.cond.for.cond.cleanup_crit_edge

for.body.60.lr.ph:                                ; preds = %for.cond.cleanup
  %14 = and i32 %n, -4
  %15 = zext i32 %14 to i64
  %16 = and i32 %n, -4
  %17 = add i32 %n, -1
  %xtraiter = and i32 %n, 1
  %lcmp.mod = icmp eq i32 %xtraiter, 0
  br i1 %lcmp.mod, label %for.body.60.lr.ph.split, label %for.body.60.prol

for.body.60.prol:                                 ; preds = %for.body.60.lr.ph
  %arrayidx64.prol = getelementptr inbounds float, float* %buf, i64 %15
  %18 = load float, float* %arrayidx64.prol, align 4, !tbaa !7
  %cmp65.prol = fcmp olt float %18, %min.1.2
  %idx_min.3.prol = select i1 %cmp65.prol, i32 %14, i32 %idx_min.1.2
  %min.3.prol = select i1 %cmp65.prol, float %18, float %min.1.2
  %cmp69.prol = fcmp ogt float %18, %max.1.2
  %max.3.prol = select i1 %cmp69.prol, float %18, float %max.1.2
  %idx_max.3.prol = select i1 %cmp69.prol, i32 %14, i32 %idx_max.1.2
  %indvars.iv.next.prol = or i64 %15, 1
  br label %for.body.60.lr.ph.split

for.body.60.lr.ph.split:                          ; preds = %for.body.60.lr.ph, %for.body.60.prol
  %idx_max.3.lcssa.unr = phi i32 [ 0, %for.body.60.lr.ph ], [ %idx_max.3.prol, %for.body.60.prol ]
  %max.3.lcssa.unr = phi float [ 0.000000e+00, %for.body.60.lr.ph ], [ %max.3.prol, %for.body.60.prol ]
  %min.3.lcssa.unr = phi float [ 0.000000e+00, %for.body.60.lr.ph ], [ %min.3.prol, %for.body.60.prol ]
  %idx_min.3.lcssa.unr = phi i32 [ 0, %for.body.60.lr.ph ], [ %idx_min.3.prol, %for.body.60.prol ]
  %indvars.iv.unr = phi i64 [ %15, %for.body.60.lr.ph ], [ %indvars.iv.next.prol, %for.body.60.prol ]
  %min.2144.unr = phi float [ %min.1.2, %for.body.60.lr.ph ], [ %min.3.prol, %for.body.60.prol ]
  %idx_max.2143.unr = phi i32 [ %idx_max.1.2, %for.body.60.lr.ph ], [ %idx_max.3.prol, %for.body.60.prol ]
  %max.2142.unr = phi float [ %max.1.2, %for.body.60.lr.ph ], [ %max.3.prol, %for.body.60.prol ]
  %idx_min.2141.unr = phi i32 [ %idx_min.1.2, %for.body.60.lr.ph ], [ %idx_min.3.prol, %for.body.60.prol ]
  %19 = icmp eq i32 %17, %16
  br i1 %19, label %for.cond.cleanup.59.loopexit, label %for.body.60.lr.ph.split.split

for.body.60.lr.ph.split.split:                    ; preds = %for.body.60.lr.ph.split
  br label %for.body.60

for.cond.cleanup.59.loopexit.unr-lcssa:           ; preds = %for.body.60
  %idx_max.3.1.lcssa = phi i32 [ %idx_max.3.1, %for.body.60 ]
  %max.3.1.lcssa = phi float [ %max.3.1, %for.body.60 ]
  %min.3.1.lcssa = phi float [ %min.3.1, %for.body.60 ]
  %idx_min.3.1.lcssa = phi i32 [ %idx_min.3.1, %for.body.60 ]
  br label %for.cond.cleanup.59.loopexit

for.cond.cleanup.59.loopexit:                     ; preds = %for.body.60.lr.ph.split, %for.cond.cleanup.59.loopexit.unr-lcssa
  %idx_max.3.lcssa = phi i32 [ %idx_max.3.lcssa.unr, %for.body.60.lr.ph.split ], [ %idx_max.3.1.lcssa, %for.cond.cleanup.59.loopexit.unr-lcssa ]
  %max.3.lcssa = phi float [ %max.3.lcssa.unr, %for.body.60.lr.ph.split ], [ %max.3.1.lcssa, %for.cond.cleanup.59.loopexit.unr-lcssa ]
  %min.3.lcssa = phi float [ %min.3.lcssa.unr, %for.body.60.lr.ph.split ], [ %min.3.1.lcssa, %for.cond.cleanup.59.loopexit.unr-lcssa ]
  %idx_min.3.lcssa = phi i32 [ %idx_min.3.lcssa.unr, %for.body.60.lr.ph.split ], [ %idx_min.3.1.lcssa, %for.cond.cleanup.59.loopexit.unr-lcssa ]
  br label %for.cond.cleanup.59

for.cond.cleanup.59:                              ; preds = %for.cond.cleanup.59.loopexit, %for.cond.cleanup
  %min.2.lcssa = phi float [ %min.1.2, %for.cond.cleanup ], [ %min.3.lcssa, %for.cond.cleanup.59.loopexit ]
  %idx_max.2.lcssa = phi i32 [ %idx_max.1.2, %for.cond.cleanup ], [ %idx_max.3.lcssa, %for.cond.cleanup.59.loopexit ]
  %max.2.lcssa = phi float [ %max.1.2, %for.cond.cleanup ], [ %max.3.lcssa, %for.cond.cleanup.59.loopexit ]
  %idx_min.2.lcssa = phi i32 [ %idx_min.1.2, %for.cond.cleanup ], [ %idx_min.3.lcssa, %for.cond.cleanup.59.loopexit ]
  store i32 %idx_min.2.lcssa, i32* %idx_min_, align 4, !tbaa !9
  store float %min.2.lcssa, float* %min_, align 4, !tbaa !7
  store i32 %idx_max.2.lcssa, i32* %idx_max_, align 4, !tbaa !9
  store float %max.2.lcssa, float* %max_, align 4, !tbaa !7
  ret void

for.body.60:                                      ; preds = %for.body.60, %for.body.60.lr.ph.split.split
  %indvars.iv = phi i64 [ %indvars.iv.unr, %for.body.60.lr.ph.split.split ], [ %indvars.iv.next.1, %for.body.60 ]
  %min.2144 = phi float [ %min.2144.unr, %for.body.60.lr.ph.split.split ], [ %min.3.1, %for.body.60 ]
  %idx_max.2143 = phi i32 [ %idx_max.2143.unr, %for.body.60.lr.ph.split.split ], [ %idx_max.3.1, %for.body.60 ]
  %max.2142 = phi float [ %max.2142.unr, %for.body.60.lr.ph.split.split ], [ %max.3.1, %for.body.60 ]
  %idx_min.2141 = phi i32 [ %idx_min.2141.unr, %for.body.60.lr.ph.split.split ], [ %idx_min.3.1, %for.body.60 ]
  %arrayidx64 = getelementptr inbounds float, float* %buf, i64 %indvars.iv
  %20 = load float, float* %arrayidx64, align 4, !tbaa !7
  %cmp65 = fcmp olt float %20, %min.2144
  %21 = trunc i64 %indvars.iv to i32
  %idx_min.3 = select i1 %cmp65, i32 %21, i32 %idx_min.2141
  %min.3 = select i1 %cmp65, float %20, float %min.2144
  %cmp69 = fcmp ogt float %20, %max.2142
  %max.3 = select i1 %cmp69, float %20, float %max.2142
  %idx_max.3 = select i1 %cmp69, i32 %21, i32 %idx_max.2143
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %arrayidx64.1 = getelementptr inbounds float, float* %buf, i64 %indvars.iv.next
  %22 = load float, float* %arrayidx64.1, align 4, !tbaa !7
  %cmp65.1 = fcmp olt float %22, %min.3
  %23 = trunc i64 %indvars.iv.next to i32
  %idx_min.3.1 = select i1 %cmp65.1, i32 %23, i32 %idx_min.3
  %min.3.1 = select i1 %cmp65.1, float %22, float %min.3
  %cmp69.1 = fcmp ogt float %22, %max.3
  %max.3.1 = select i1 %cmp69.1, float %22, float %max.3
  %idx_max.3.1 = select i1 %cmp69.1, i32 %23, i32 %idx_max.3
  %indvars.iv.next.1 = add nsw i64 %indvars.iv, 2
  %lftr.wideiv.1 = trunc i64 %indvars.iv.next.1 to i32
  %exitcond.1 = icmp eq i32 %lftr.wideiv.1, %n
  br i1 %exitcond.1, label %for.cond.cleanup.59.loopexit.unr-lcssa, label %for.body.60
}

; Function Attrs: nounwind uwtable
define void @minmax_vec2(i32 %n, float* nocapture readonly %buf, i32* nocapture %idx_min_, i32* nocapture %idx_max_, float* nocapture %min_, float* nocapture %max_) #0 {
entry:
  %and = and i32 %n, -4
  %cmp.188 = icmp eq i32 %and, 0
  br i1 %cmp.188, label %for.cond.cleanup, label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %entry
  %0 = zext i32 %and to i64
  br label %for.body

for.cond.cleanup.loopexit:                        ; preds = %for.body
  %.lcssa215 = phi <2 x i64> [ %42, %for.body ]
  %.lcssa214 = phi <2 x i64> [ %39, %for.body ]
  %.lcssa213 = phi <4 x float> [ %35, %for.body ]
  %.lcssa = phi <4 x float> [ %34, %for.body ]
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %entry
  %sse_idx_min.0.lcssa = phi <2 x i64> [ zeroinitializer, %entry ], [ %.lcssa214, %for.cond.cleanup.loopexit ]
  %sse_idx_max.0.lcssa = phi <2 x i64> [ zeroinitializer, %entry ], [ %.lcssa215, %for.cond.cleanup.loopexit ]
  %sse_min.0.lcssa = phi <4 x float> [ <float 0x47EFFFFFE0000000, float 0x47EFFFFFE0000000, float 0x47EFFFFFE0000000, float 0x47EFFFFFE0000000>, %entry ], [ %.lcssa, %for.cond.cleanup.loopexit ]
  %sse_max.0.lcssa = phi <4 x float> [ <float 0x3810000000000000, float 0x3810000000000000, float 0x3810000000000000, float 0x3810000000000000>, %entry ], [ %.lcssa213, %for.cond.cleanup.loopexit ]
  %1 = shufflevector <4 x float> %sse_min.0.lcssa, <4 x float> undef, <4 x i32> <i32 2, i32 3, i32 0, i32 0>
  %2 = shufflevector <4 x float> %sse_max.0.lcssa, <4 x float> undef, <4 x i32> <i32 2, i32 3, i32 0, i32 0>
  %3 = bitcast <2 x i64> %sse_idx_min.0.lcssa to <4 x i32>
  %shuffle24 = shufflevector <4 x i32> %3, <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 0, i32 0>
  %4 = bitcast <2 x i64> %sse_idx_max.0.lcssa to <4 x i32>
  %shuffle28 = shufflevector <4 x i32> %4, <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 0, i32 0>
  %cmpps.i.172 = tail call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %1, <4 x float> %sse_min.0.lcssa, i8 1) #1
  %cmpps.i.171 = tail call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %sse_max.0.lcssa, <4 x float> %2, i8 1) #1
  %5 = tail call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %sse_min.0.lcssa, <4 x float> %1, <4 x float> %cmpps.i.172) #1
  %6 = tail call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %sse_max.0.lcssa, <4 x float> %2, <4 x float> %cmpps.i.171) #1
  %7 = bitcast <2 x i64> %sse_idx_min.0.lcssa to <4 x float>
  %8 = bitcast <4 x i32> %shuffle24 to <4 x float>
  %9 = tail call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %7, <4 x float> %8, <4 x float> %cmpps.i.172) #1
  %10 = bitcast <2 x i64> %sse_idx_max.0.lcssa to <4 x float>
  %11 = bitcast <4 x i32> %shuffle28 to <4 x float>
  %12 = tail call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %10, <4 x float> %11, <4 x float> %cmpps.i.171) #1
  %13 = shufflevector <4 x float> %5, <4 x float> undef, <4 x i32> <i32 1, i32 0, i32 0, i32 0>
  %14 = shufflevector <4 x float> %6, <4 x float> undef, <4 x i32> <i32 1, i32 0, i32 0, i32 0>
  %cmpps.i.170 = tail call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %13, <4 x float> %5, i8 1) #1
  %cmpps.i.169 = tail call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %6, <4 x float> %14, i8 1) #1
  %15 = tail call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %5, <4 x float> %13, <4 x float> %cmpps.i.170) #1
  %16 = tail call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %6, <4 x float> %14, <4 x float> %cmpps.i.169) #1
  %17 = shufflevector <4 x float> %9, <4 x float> undef, <4 x i32> <i32 1, i32 0, i32 0, i32 0>
  %18 = tail call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %9, <4 x float> %17, <4 x float> %cmpps.i.170) #1
  %19 = shufflevector <4 x float> %12, <4 x float> undef, <4 x i32> <i32 1, i32 0, i32 0, i32 0>
  %20 = tail call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %12, <4 x float> %19, <4 x float> %cmpps.i.169) #1
  %vecext.i.168 = extractelement <4 x float> %15, i32 0
  %21 = bitcast float %vecext.i.168 to i32
  %vecext.i = extractelement <4 x float> %16, i32 0
  %22 = bitcast float %vecext.i to i32
  %23 = bitcast <4 x float> %18 to <4 x i32>
  %vecext = extractelement <4 x i32> %23, i32 0
  %24 = bitcast <4 x float> %20 to <4 x i32>
  %vecext66 = extractelement <4 x i32> %24, i32 0
  %cmp70.179 = icmp ult i32 %and, %n
  br i1 %cmp70.179, label %for.body.73.lr.ph, label %for.cond.cleanup.72

for.body.73.lr.ph:                                ; preds = %for.cond.cleanup
  %25 = and i32 %n, -4
  %26 = zext i32 %25 to i64
  %27 = and i32 %n, -4
  %28 = add i32 %n, -1
  %xtraiter = and i32 %n, 1
  %lcmp.mod = icmp eq i32 %xtraiter, 0
  br i1 %lcmp.mod, label %for.body.73.lr.ph.split, label %for.body.73.prol

for.body.73.prol:                                 ; preds = %for.body.73.lr.ph
  %arrayidx76.prol = getelementptr inbounds float, float* %buf, i64 %26
  %29 = load float, float* %arrayidx76.prol, align 4, !tbaa !7
  %cmp77.prol = fcmp olt float %29, %vecext.i.168
  %30 = bitcast float %29 to i32
  %min.sroa.0.0.177.prol = select i1 %cmp77.prol, i32 %30, i32 %21
  %idx_min.1.prol = select i1 %cmp77.prol, i32 %25, i32 %vecext
  %cmp79.prol = fcmp ogt float %29, %vecext.i
  %max.sroa.0.0.175.prol = select i1 %cmp79.prol, i32 %30, i32 %22
  %idx_max.1.prol = select i1 %cmp79.prol, i32 %25, i32 %vecext66
  %indvars.iv.next.prol = or i64 %26, 1
  br label %for.body.73.lr.ph.split

for.body.73.lr.ph.split:                          ; preds = %for.body.73.lr.ph, %for.body.73.prol
  %idx_max.1.lcssa.unr = phi i32 [ 0, %for.body.73.lr.ph ], [ %idx_max.1.prol, %for.body.73.prol ]
  %max.sroa.0.0.175.lcssa.unr = phi i32 [ 0, %for.body.73.lr.ph ], [ %max.sroa.0.0.175.prol, %for.body.73.prol ]
  %idx_min.1.lcssa.unr = phi i32 [ 0, %for.body.73.lr.ph ], [ %idx_min.1.prol, %for.body.73.prol ]
  %min.sroa.0.0.177.lcssa.unr = phi i32 [ 0, %for.body.73.lr.ph ], [ %min.sroa.0.0.177.prol, %for.body.73.prol ]
  %indvars.iv.unr = phi i64 [ %26, %for.body.73.lr.ph ], [ %indvars.iv.next.prol, %for.body.73.prol ]
  %idx_max.0183.unr = phi i32 [ %vecext66, %for.body.73.lr.ph ], [ %idx_max.1.prol, %for.body.73.prol ]
  %idx_min.0182.unr = phi i32 [ %vecext, %for.body.73.lr.ph ], [ %idx_min.1.prol, %for.body.73.prol ]
  %max.sroa.0.0.176181.unr = phi i32 [ %22, %for.body.73.lr.ph ], [ %max.sroa.0.0.175.prol, %for.body.73.prol ]
  %min.sroa.0.0.178180.unr = phi i32 [ %21, %for.body.73.lr.ph ], [ %min.sroa.0.0.177.prol, %for.body.73.prol ]
  %31 = icmp eq i32 %28, %27
  br i1 %31, label %for.cond.cleanup.72.loopexit, label %for.body.73.lr.ph.split.split

for.body.73.lr.ph.split.split:                    ; preds = %for.body.73.lr.ph.split
  br label %for.body.73

for.body:                                         ; preds = %for.body.lr.ph, %for.body
  %indvars.iv202 = phi i64 [ 0, %for.body.lr.ph ], [ %indvars.iv.next203, %for.body ]
  %sse_idx_min.0194 = phi <2 x i64> [ zeroinitializer, %for.body.lr.ph ], [ %39, %for.body ]
  %sse_idx_max.0193 = phi <2 x i64> [ zeroinitializer, %for.body.lr.ph ], [ %42, %for.body ]
  %sse_min.0192 = phi <4 x float> [ <float 0x47EFFFFFE0000000, float 0x47EFFFFFE0000000, float 0x47EFFFFFE0000000, float 0x47EFFFFFE0000000>, %for.body.lr.ph ], [ %34, %for.body ]
  %sse_max.0191 = phi <4 x float> [ <float 0x3810000000000000, float 0x3810000000000000, float 0x3810000000000000, float 0x3810000000000000>, %for.body.lr.ph ], [ %35, %for.body ]
  %sse_idx.0190 = phi <2 x i64> [ <i64 4294967296, i64 12884901890>, %for.body.lr.ph ], [ %44, %for.body ]
  %arrayidx = getelementptr inbounds float, float* %buf, i64 %indvars.iv202
  %32 = bitcast float* %arrayidx to <4 x float>*
  %33 = load <4 x float>, <4 x float>* %32, align 16, !tbaa !11
  %cmpps.i.167 = tail call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %33, <4 x float> %sse_min.0192, i8 1) #1
  %cmpps.i = tail call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %sse_max.0191, <4 x float> %33, i8 1) #1
  %34 = tail call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %sse_min.0192, <4 x float> %33, <4 x float> %cmpps.i.167) #1
  %35 = tail call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %sse_max.0191, <4 x float> %33, <4 x float> %cmpps.i) #1
  %36 = bitcast <2 x i64> %sse_idx_min.0194 to <4 x float>
  %37 = bitcast <2 x i64> %sse_idx.0190 to <4 x float>
  %38 = tail call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %36, <4 x float> %37, <4 x float> %cmpps.i.167) #1
  %39 = bitcast <4 x float> %38 to <2 x i64>
  %40 = bitcast <2 x i64> %sse_idx_max.0193 to <4 x float>
  %41 = tail call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %40, <4 x float> %37, <4 x float> %cmpps.i) #1
  %42 = bitcast <4 x float> %41 to <2 x i64>
  %43 = bitcast <2 x i64> %sse_idx.0190 to <4 x i32>
  %add.i = add <4 x i32> %43, <i32 4, i32 4, i32 4, i32 4>
  %44 = bitcast <4 x i32> %add.i to <2 x i64>
  %indvars.iv.next203 = add nuw nsw i64 %indvars.iv202, 4
  %cmp = icmp ult i64 %indvars.iv.next203, %0
  br i1 %cmp, label %for.body, label %for.cond.cleanup.loopexit

for.cond.cleanup.72.loopexit.unr-lcssa:           ; preds = %for.body.73
  %idx_max.1.1.lcssa = phi i32 [ %idx_max.1.1, %for.body.73 ]
  %max.sroa.0.0.175.1.lcssa = phi i32 [ %max.sroa.0.0.175.1, %for.body.73 ]
  %idx_min.1.1.lcssa = phi i32 [ %idx_min.1.1, %for.body.73 ]
  %min.sroa.0.0.177.1.lcssa = phi i32 [ %min.sroa.0.0.177.1, %for.body.73 ]
  br label %for.cond.cleanup.72.loopexit

for.cond.cleanup.72.loopexit:                     ; preds = %for.body.73.lr.ph.split, %for.cond.cleanup.72.loopexit.unr-lcssa
  %idx_max.1.lcssa = phi i32 [ %idx_max.1.lcssa.unr, %for.body.73.lr.ph.split ], [ %idx_max.1.1.lcssa, %for.cond.cleanup.72.loopexit.unr-lcssa ]
  %max.sroa.0.0.175.lcssa = phi i32 [ %max.sroa.0.0.175.lcssa.unr, %for.body.73.lr.ph.split ], [ %max.sroa.0.0.175.1.lcssa, %for.cond.cleanup.72.loopexit.unr-lcssa ]
  %idx_min.1.lcssa = phi i32 [ %idx_min.1.lcssa.unr, %for.body.73.lr.ph.split ], [ %idx_min.1.1.lcssa, %for.cond.cleanup.72.loopexit.unr-lcssa ]
  %min.sroa.0.0.177.lcssa = phi i32 [ %min.sroa.0.0.177.lcssa.unr, %for.body.73.lr.ph.split ], [ %min.sroa.0.0.177.1.lcssa, %for.cond.cleanup.72.loopexit.unr-lcssa ]
  br label %for.cond.cleanup.72

for.cond.cleanup.72:                              ; preds = %for.cond.cleanup.72.loopexit, %for.cond.cleanup
  %idx_max.0.lcssa = phi i32 [ %vecext66, %for.cond.cleanup ], [ %idx_max.1.lcssa, %for.cond.cleanup.72.loopexit ]
  %idx_min.0.lcssa = phi i32 [ %vecext, %for.cond.cleanup ], [ %idx_min.1.lcssa, %for.cond.cleanup.72.loopexit ]
  %max.sroa.0.0.176.lcssa = phi i32 [ %22, %for.cond.cleanup ], [ %max.sroa.0.0.175.lcssa, %for.cond.cleanup.72.loopexit ]
  %min.sroa.0.0.178.lcssa = phi i32 [ %21, %for.cond.cleanup ], [ %min.sroa.0.0.177.lcssa, %for.cond.cleanup.72.loopexit ]
  store i32 %idx_min.0.lcssa, i32* %idx_min_, align 4, !tbaa !9
  %45 = bitcast float* %min_ to i32*
  store i32 %min.sroa.0.0.178.lcssa, i32* %45, align 4, !tbaa !7
  store i32 %idx_max.0.lcssa, i32* %idx_max_, align 4, !tbaa !9
  %46 = bitcast float* %max_ to i32*
  store i32 %max.sroa.0.0.176.lcssa, i32* %46, align 4, !tbaa !7
  ret void

for.body.73:                                      ; preds = %for.body.73, %for.body.73.lr.ph.split.split
  %indvars.iv = phi i64 [ %indvars.iv.unr, %for.body.73.lr.ph.split.split ], [ %indvars.iv.next.1, %for.body.73 ]
  %idx_max.0183 = phi i32 [ %idx_max.0183.unr, %for.body.73.lr.ph.split.split ], [ %idx_max.1.1, %for.body.73 ]
  %idx_min.0182 = phi i32 [ %idx_min.0182.unr, %for.body.73.lr.ph.split.split ], [ %idx_min.1.1, %for.body.73 ]
  %max.sroa.0.0.176181 = phi i32 [ %max.sroa.0.0.176181.unr, %for.body.73.lr.ph.split.split ], [ %max.sroa.0.0.175.1, %for.body.73 ]
  %min.sroa.0.0.178180 = phi i32 [ %min.sroa.0.0.178180.unr, %for.body.73.lr.ph.split.split ], [ %min.sroa.0.0.177.1, %for.body.73 ]
  %arrayidx76 = getelementptr inbounds float, float* %buf, i64 %indvars.iv
  %47 = load float, float* %arrayidx76, align 4, !tbaa !7
  %48 = bitcast i32 %min.sroa.0.0.178180 to float
  %cmp77 = fcmp olt float %47, %48
  %49 = bitcast float %47 to i32
  %min.sroa.0.0.177 = select i1 %cmp77, i32 %49, i32 %min.sroa.0.0.178180
  %50 = trunc i64 %indvars.iv to i32
  %idx_min.1 = select i1 %cmp77, i32 %50, i32 %idx_min.0182
  %51 = bitcast i32 %max.sroa.0.0.176181 to float
  %cmp79 = fcmp ogt float %47, %51
  %max.sroa.0.0.175 = select i1 %cmp79, i32 %49, i32 %max.sroa.0.0.176181
  %idx_max.1 = select i1 %cmp79, i32 %50, i32 %idx_max.0183
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %arrayidx76.1 = getelementptr inbounds float, float* %buf, i64 %indvars.iv.next
  %52 = load float, float* %arrayidx76.1, align 4, !tbaa !7
  %53 = bitcast i32 %min.sroa.0.0.177 to float
  %cmp77.1 = fcmp olt float %52, %53
  %54 = bitcast float %52 to i32
  %min.sroa.0.0.177.1 = select i1 %cmp77.1, i32 %54, i32 %min.sroa.0.0.177
  %55 = trunc i64 %indvars.iv.next to i32
  %idx_min.1.1 = select i1 %cmp77.1, i32 %55, i32 %idx_min.1
  %56 = bitcast i32 %max.sroa.0.0.175 to float
  %cmp79.1 = fcmp ogt float %52, %56
  %max.sroa.0.0.175.1 = select i1 %cmp79.1, i32 %54, i32 %max.sroa.0.0.175
  %idx_max.1.1 = select i1 %cmp79.1, i32 %55, i32 %idx_max.1
  %indvars.iv.next.1 = add nsw i64 %indvars.iv, 2
  %lftr.wideiv.1 = trunc i64 %indvars.iv.next.1 to i32
  %exitcond.1 = icmp eq i32 %lftr.wideiv.1, %n
  br i1 %exitcond.1, label %for.cond.cleanup.72.loopexit.unr-lcssa, label %for.body.73
}

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** nocapture readonly %argv) #0 {
entry:
  %curt.i.186 = alloca %struct.timeval, align 8
  %curt.i.178 = alloca %struct.timeval, align 8
  %curt.i.140 = alloca %struct.timeval, align 8
  %curt.i.132 = alloca %struct.timeval, align 8
  %curt.i.124 = alloca %struct.timeval, align 8
  %curt.i = alloca %struct.timeval, align 8
  %buf = alloca float*, align 8
  %cmp = icmp slt i32 %argc, 2
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %0 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !12
  %1 = load i8*, i8** %argv, align 8, !tbaa !12
  %call = tail call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %0, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i64 0, i64 0), i8* %1) #4
  br label %return

if.end:                                           ; preds = %entry
  %arrayidx1 = getelementptr inbounds i8*, i8** %argv, i64 1
  %2 = load i8*, i8** %arrayidx1, align 8, !tbaa !12
  %call.i = tail call i64 @strtol(i8* nocapture %2, i8** null, i32 10) #1
  %conv = trunc i64 %call.i to i32
  %3 = bitcast float** %buf to i8*
  call void @llvm.lifetime.start(i64 8, i8* %3) #1
  %4 = bitcast float** %buf to i8**
  %conv3 = shl i64 %call.i, 2
  %mul = and i64 %conv3, 17179869180
  %call4 = call i32 @posix_memalign(i8** %4, i64 16, i64 %mul) #1
  %call5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([44 x i8], [44 x i8]* @.str.1, i64 0, i64 0), i32 %conv) #1
  %call6 = call i64 @time(i64* null) #1
  %conv7 = trunc i64 %call6 to i32
  call void @srand(i32 %conv7) #1
  %cmp8.214 = icmp eq i32 %conv, 0
  br i1 %cmp8.214, label %for.cond.cleanup, label %for.body.preheader

for.body.preheader:                               ; preds = %if.end
  br label %for.body

for.cond.cleanup.loopexit:                        ; preds = %for.body
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %if.end
  %puts = call i32 @puts(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str, i64 0, i64 0))
  %5 = bitcast %struct.timeval* %curt.i to i8*
  call void @llvm.lifetime.start(i64 16, i8* %5) #1
  %call.i.123 = call i32 @gettimeofday(%struct.timeval* %curt.i, %struct.timezone* null) #1
  %tv_sec.i = getelementptr inbounds %struct.timeval, %struct.timeval* %curt.i, i64 0, i32 0
  %6 = load i64, i64* %tv_sec.i, align 8, !tbaa !1
  %conv.i = sitofp i64 %6 to double
  %tv_usec.i = getelementptr inbounds %struct.timeval, %struct.timeval* %curt.i, i64 0, i32 1
  %7 = load i64, i64* %tv_usec.i, align 8, !tbaa !6
  %conv1.i = sitofp i64 %7 to double
  %div.i = fdiv double %conv1.i, 1.000000e+06
  %add.i = fadd double %conv.i, %div.i
  call void @llvm.lifetime.end(i64 16, i8* %5) #1
  %8 = load float*, float** %buf, align 8, !tbaa !12
  br i1 %cmp8.214, label %minmax.exit, label %for.body.i.preheader

for.body.i.preheader:                             ; preds = %for.cond.cleanup
  %9 = trunc i64 %call.i to i32
  %xtraiter248 = and i32 %9, 1
  %lcmp.mod249 = icmp eq i32 %xtraiter248, 0
  br i1 %lcmp.mod249, label %for.body.i.preheader.split, label %for.body.i.prol

for.body.i.prol:                                  ; preds = %for.body.i.preheader
  %10 = load float, float* %8, align 4, !tbaa !7
  %cmp1.i.prol = fcmp olt float %10, 0x47EFFFFFE0000000
  %min.1.i.prol = select i1 %cmp1.i.prol, float %10, float 0x47EFFFFFE0000000
  %cmp2.i.prol = fcmp ogt float %10, 0x3810000000000000
  %max.1.i.prol = select i1 %cmp2.i.prol, float %10, float 0x3810000000000000
  br label %for.body.i.preheader.split

for.body.i.preheader.split:                       ; preds = %for.body.i.preheader, %for.body.i.prol
  %max.1.i.lcssa.unr = phi float [ 0.000000e+00, %for.body.i.preheader ], [ %max.1.i.prol, %for.body.i.prol ]
  %min.1.i.lcssa.unr = phi float [ 0.000000e+00, %for.body.i.preheader ], [ %min.1.i.prol, %for.body.i.prol ]
  %indvars.iv.i.unr = phi i64 [ 0, %for.body.i.preheader ], [ 1, %for.body.i.prol ]
  %max.027.i.unr = phi float [ 0x3810000000000000, %for.body.i.preheader ], [ %max.1.i.prol, %for.body.i.prol ]
  %min.026.i.unr = phi float [ 0x47EFFFFFE0000000, %for.body.i.preheader ], [ %min.1.i.prol, %for.body.i.prol ]
  %11 = icmp eq i32 %9, 1
  br i1 %11, label %for.cond.for.end_crit_edge.i, label %for.body.i.preheader.split.split

for.body.i.preheader.split.split:                 ; preds = %for.body.i.preheader.split
  br label %for.body.i

for.body.i:                                       ; preds = %for.body.i, %for.body.i.preheader.split.split
  %indvars.iv.i = phi i64 [ %indvars.iv.i.unr, %for.body.i.preheader.split.split ], [ %indvars.iv.next.i.1, %for.body.i ]
  %idx_min.029.i = phi i64 [ 0, %for.body.i.preheader.split.split ], [ %idx_min.1.i.1, %for.body.i ]
  %max.027.i = phi float [ %max.027.i.unr, %for.body.i.preheader.split.split ], [ %max.1.i.1, %for.body.i ]
  %min.026.i = phi float [ %min.026.i.unr, %for.body.i.preheader.split.split ], [ %min.1.i.1, %for.body.i ]
  %idx_max.025.i = phi i64 [ 0, %for.body.i.preheader.split.split ], [ %idx_max.1.i.1, %for.body.i ]
  %arrayidx.i = getelementptr inbounds float, float* %8, i64 %indvars.iv.i
  %12 = load float, float* %arrayidx.i, align 4, !tbaa !7
  %cmp1.i = fcmp olt float %12, %min.026.i
  %min.1.i = select i1 %cmp1.i, float %12, float %min.026.i
  %idx_min.1.i = select i1 %cmp1.i, i64 %indvars.iv.i, i64 %idx_min.029.i
  %cmp2.i = fcmp ogt float %12, %max.027.i
  %idx_max.1.i = select i1 %cmp2.i, i64 %indvars.iv.i, i64 %idx_max.025.i
  %max.1.i = select i1 %cmp2.i, float %12, float %max.027.i
  %indvars.iv.next.i = add nuw nsw i64 %indvars.iv.i, 1
  %arrayidx.i.1 = getelementptr inbounds float, float* %8, i64 %indvars.iv.next.i
  %13 = load float, float* %arrayidx.i.1, align 4, !tbaa !7
  %cmp1.i.1 = fcmp olt float %13, %min.1.i
  %min.1.i.1 = select i1 %cmp1.i.1, float %13, float %min.1.i
  %idx_min.1.i.1 = select i1 %cmp1.i.1, i64 %indvars.iv.next.i, i64 %idx_min.1.i
  %cmp2.i.1 = fcmp ogt float %13, %max.1.i
  %idx_max.1.i.1 = select i1 %cmp2.i.1, i64 %indvars.iv.next.i, i64 %idx_max.1.i
  %max.1.i.1 = select i1 %cmp2.i.1, float %13, float %max.1.i
  %indvars.iv.next.i.1 = add nsw i64 %indvars.iv.i, 2
  %lftr.wideiv.1 = trunc i64 %indvars.iv.next.i.1 to i32
  %exitcond.1 = icmp eq i32 %lftr.wideiv.1, %conv
  br i1 %exitcond.1, label %for.cond.for.end_crit_edge.i.unr-lcssa, label %for.body.i

for.cond.for.end_crit_edge.i.unr-lcssa:           ; preds = %for.body.i
  %max.1.i.1.lcssa = phi float [ %max.1.i.1, %for.body.i ]
  %idx_max.1.i.1.lcssa = phi i64 [ %idx_max.1.i.1, %for.body.i ]
  %idx_min.1.i.1.lcssa = phi i64 [ %idx_min.1.i.1, %for.body.i ]
  %min.1.i.1.lcssa = phi float [ %min.1.i.1, %for.body.i ]
  %phitmp250 = trunc i64 %idx_min.1.i.1.lcssa to i32
  %phitmp251 = trunc i64 %idx_max.1.i.1.lcssa to i32
  br label %for.cond.for.end_crit_edge.i

for.cond.for.end_crit_edge.i:                     ; preds = %for.body.i.preheader.split, %for.cond.for.end_crit_edge.i.unr-lcssa
  %max.1.i.lcssa = phi float [ %max.1.i.lcssa.unr, %for.body.i.preheader.split ], [ %max.1.i.1.lcssa, %for.cond.for.end_crit_edge.i.unr-lcssa ]
  %idx_max.1.i.lcssa = phi i32 [ 0, %for.body.i.preheader.split ], [ %phitmp251, %for.cond.for.end_crit_edge.i.unr-lcssa ]
  %idx_min.1.i.lcssa = phi i32 [ 0, %for.body.i.preheader.split ], [ %phitmp250, %for.cond.for.end_crit_edge.i.unr-lcssa ]
  %min.1.i.lcssa = phi float [ %min.1.i.lcssa.unr, %for.body.i.preheader.split ], [ %min.1.i.1.lcssa, %for.cond.for.end_crit_edge.i.unr-lcssa ]
  %phitmp = fpext float %min.1.i.lcssa to double
  %phitmp206 = fpext float %max.1.i.lcssa to double
  br label %minmax.exit

minmax.exit:                                      ; preds = %for.cond.cleanup, %for.cond.for.end_crit_edge.i
  %idx_min.0.lcssa.i = phi i32 [ %idx_min.1.i.lcssa, %for.cond.for.end_crit_edge.i ], [ 0, %for.cond.cleanup ]
  %max.0.lcssa.i = phi double [ %phitmp206, %for.cond.for.end_crit_edge.i ], [ 0x3810000000000000, %for.cond.cleanup ]
  %min.0.lcssa.i = phi double [ %phitmp, %for.cond.for.end_crit_edge.i ], [ 0x47EFFFFFE0000000, %for.cond.cleanup ]
  %idx_max.0.lcssa.i = phi i32 [ %idx_max.1.i.lcssa, %for.cond.for.end_crit_edge.i ], [ 0, %for.cond.cleanup ]
  %14 = bitcast %struct.timeval* %curt.i.132 to i8*
  call void @llvm.lifetime.start(i64 16, i8* %14) #1
  %call.i.133 = call i32 @gettimeofday(%struct.timeval* %curt.i.132, %struct.timezone* null) #1
  %tv_sec.i.134 = getelementptr inbounds %struct.timeval, %struct.timeval* %curt.i.132, i64 0, i32 0
  %15 = load i64, i64* %tv_sec.i.134, align 8, !tbaa !1
  %conv.i.135 = sitofp i64 %15 to double
  %tv_usec.i.136 = getelementptr inbounds %struct.timeval, %struct.timeval* %curt.i.132, i64 0, i32 1
  %16 = load i64, i64* %tv_usec.i.136, align 8, !tbaa !6
  %conv1.i.137 = sitofp i64 %16 to double
  %div.i.138 = fdiv double %conv1.i.137, 1.000000e+06
  %add.i.139 = fadd double %conv.i.135, %div.i.138
  call void @llvm.lifetime.end(i64 16, i8* %14) #1
  %sub = fsub double %add.i.139, %add.i
  %conv18 = uitofp i64 %mul to double
  %div = fmul double %conv18, 0x3EB0000000000000
  %div19 = fdiv double %div, %sub
  %div20 = fdiv double 0x3EB0000000000000, %sub
  %17 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !12
  %mul21 = fmul double %sub, 1.000000e+03
  %call22 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([107 x i8], [107 x i8]* @.str.3, i64 0, i64 0), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i64 0, i64 0), double %mul21, i64 4, double %div, double %div19, i64 1, double 0x3EB0000000000000, double %div20) #4
  %call24 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.5, i64 0, i64 0), double %min.0.lcssa.i, i32 %idx_min.0.lcssa.i) #1
  %call26 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.6, i64 0, i64 0), double %max.0.lcssa.i, i32 %idx_max.0.lcssa.i) #1
  %18 = bitcast %struct.timeval* %curt.i.140 to i8*
  call void @llvm.lifetime.start(i64 16, i8* %18) #1
  %call.i.141 = call i32 @gettimeofday(%struct.timeval* %curt.i.140, %struct.timezone* null) #1
  %tv_sec.i.142 = getelementptr inbounds %struct.timeval, %struct.timeval* %curt.i.140, i64 0, i32 0
  %19 = load i64, i64* %tv_sec.i.142, align 8, !tbaa !1
  %conv.i.143 = sitofp i64 %19 to double
  %tv_usec.i.144 = getelementptr inbounds %struct.timeval, %struct.timeval* %curt.i.140, i64 0, i32 1
  %20 = load i64, i64* %tv_usec.i.144, align 8, !tbaa !6
  %conv1.i.145 = sitofp i64 %20 to double
  %div.i.146 = fdiv double %conv1.i.145, 1.000000e+06
  %add.i.147 = fadd double %conv.i.143, %div.i.146
  call void @llvm.lifetime.end(i64 16, i8* %18) #1
  %21 = load float*, float** %buf, align 8, !tbaa !12
  %and.i = and i32 %conv, -4
  %cmp.154.i = icmp eq i32 %and.i, 0
  br i1 %cmp.154.i, label %for.cond.cleanup.i, label %for.body.lr.ph.i

for.body.lr.ph.i:                                 ; preds = %minmax.exit
  %22 = zext i32 %and.i to i64
  br label %for.body.i.154

for.cond.for.cond.cleanup_crit_edge.i:            ; preds = %for.body.i.154
  %.lcssa258 = phi <4 x float> [ %32, %for.body.i.154 ]
  %.lcssa257 = phi <4 x float> [ %29, %for.body.i.154 ]
  %.lcssa256 = phi <4 x float> [ %26, %for.body.i.154 ]
  %.lcssa255 = phi <4 x float> [ %25, %for.body.i.154 ]
  %phitmp.i.148 = bitcast <4 x float> %.lcssa257 to <4 x i32>
  %phitmp165.i = bitcast <4 x float> %.lcssa258 to <4 x i32>
  %phitmp183.i = extractelement <4 x float> %.lcssa255, i32 0
  %phitmp191.i = extractelement <4 x float> %.lcssa256, i32 0
  %phitmp192.i = extractelement <4 x float> %.lcssa255, i32 1
  %phitmp193.i = extractelement <4 x float> %.lcssa256, i32 1
  %phitmp194.i = extractelement <4 x float> %.lcssa255, i32 2
  %phitmp195.i = extractelement <4 x float> %.lcssa256, i32 2
  %phitmp196.i = extractelement <4 x float> %.lcssa255, i32 3
  %phitmp197.i = extractelement <4 x float> %.lcssa256, i32 3
  br label %for.cond.cleanup.i

for.cond.cleanup.i:                               ; preds = %for.cond.for.cond.cleanup_crit_edge.i, %minmax.exit
  %sse_idx_min.0.lcssa.i = phi <4 x i32> [ %phitmp.i.148, %for.cond.for.cond.cleanup_crit_edge.i ], [ zeroinitializer, %minmax.exit ]
  %sse_idx_max.0.lcssa.i = phi <4 x i32> [ %phitmp165.i, %for.cond.for.cond.cleanup_crit_edge.i ], [ zeroinitializer, %minmax.exit ]
  %sse_min.0.lcssa.off0.i = phi float [ %phitmp183.i, %for.cond.for.cond.cleanup_crit_edge.i ], [ 0x47EFFFFFE0000000, %minmax.exit ]
  %sse_min.0.lcssa.off32.i = phi float [ %phitmp192.i, %for.cond.for.cond.cleanup_crit_edge.i ], [ 0x47EFFFFFE0000000, %minmax.exit ]
  %sse_min.0.lcssa.off64.i = phi float [ %phitmp194.i, %for.cond.for.cond.cleanup_crit_edge.i ], [ 0x47EFFFFFE0000000, %minmax.exit ]
  %sse_min.0.lcssa.off96.i = phi float [ %phitmp196.i, %for.cond.for.cond.cleanup_crit_edge.i ], [ 0x47EFFFFFE0000000, %minmax.exit ]
  %sse_max.0.lcssa.off0.i = phi float [ %phitmp191.i, %for.cond.for.cond.cleanup_crit_edge.i ], [ 0x3810000000000000, %minmax.exit ]
  %sse_max.0.lcssa.off32.i = phi float [ %phitmp193.i, %for.cond.for.cond.cleanup_crit_edge.i ], [ 0x3810000000000000, %minmax.exit ]
  %sse_max.0.lcssa.off64.i = phi float [ %phitmp195.i, %for.cond.for.cond.cleanup_crit_edge.i ], [ 0x3810000000000000, %minmax.exit ]
  %sse_max.0.lcssa.off96.i = phi float [ %phitmp197.i, %for.cond.for.cond.cleanup_crit_edge.i ], [ 0x3810000000000000, %minmax.exit ]
  %vecext.i = extractelement <4 x i32> %sse_idx_min.0.lcssa.i, i32 0
  %vecext23.i = extractelement <4 x i32> %sse_idx_max.0.lcssa.i, i32 0
  %cmp34.i = fcmp olt float %sse_min.0.lcssa.off32.i, %sse_min.0.lcssa.off0.i
  %vecext40.i = extractelement <4 x i32> %sse_idx_min.0.lcssa.i, i32 1
  %idx_min.1.i.149 = select i1 %cmp34.i, i32 %vecext40.i, i32 %vecext.i
  %min.1.i.150 = select i1 %cmp34.i, float %sse_min.0.lcssa.off32.i, float %sse_min.0.lcssa.off0.i
  %cmp43.i = fcmp ogt float %sse_max.0.lcssa.off32.i, %sse_max.0.lcssa.off0.i
  %vecext50.i = extractelement <4 x i32> %sse_idx_max.0.lcssa.i, i32 1
  %max.1.i.151 = select i1 %cmp43.i, float %sse_max.0.lcssa.off32.i, float %sse_max.0.lcssa.off0.i
  %idx_max.1.i.152 = select i1 %cmp43.i, i32 %vecext50.i, i32 %vecext23.i
  %cmp34.1.i = fcmp olt float %sse_min.0.lcssa.off64.i, %min.1.i.150
  %vecext40.1.i = extractelement <4 x i32> %sse_idx_min.0.lcssa.i, i32 2
  %idx_min.1.1.i = select i1 %cmp34.1.i, i32 %vecext40.1.i, i32 %idx_min.1.i.149
  %min.1.1.i = select i1 %cmp34.1.i, float %sse_min.0.lcssa.off64.i, float %min.1.i.150
  %cmp43.1.i = fcmp ogt float %sse_max.0.lcssa.off64.i, %max.1.i.151
  %vecext50.1.i = extractelement <4 x i32> %sse_idx_max.0.lcssa.i, i32 2
  %max.1.1.i = select i1 %cmp43.1.i, float %sse_max.0.lcssa.off64.i, float %max.1.i.151
  %idx_max.1.1.i = select i1 %cmp43.1.i, i32 %vecext50.1.i, i32 %idx_max.1.i.152
  %cmp34.2.i = fcmp olt float %sse_min.0.lcssa.off96.i, %min.1.1.i
  %vecext40.2.i = extractelement <4 x i32> %sse_idx_min.0.lcssa.i, i32 3
  %idx_min.1.2.i = select i1 %cmp34.2.i, i32 %vecext40.2.i, i32 %idx_min.1.1.i
  %min.1.2.i = select i1 %cmp34.2.i, float %sse_min.0.lcssa.off96.i, float %min.1.1.i
  %cmp43.2.i = fcmp ogt float %sse_max.0.lcssa.off96.i, %max.1.1.i
  %vecext50.2.i = extractelement <4 x i32> %sse_idx_max.0.lcssa.i, i32 3
  %max.1.2.i = select i1 %cmp43.2.i, float %sse_max.0.lcssa.off96.i, float %max.1.1.i
  %idx_max.1.2.i = select i1 %cmp43.2.i, i32 %vecext50.2.i, i32 %idx_max.1.1.i
  %cmp57.140.i = icmp ult i32 %and.i, %conv
  br i1 %cmp57.140.i, label %for.body.60.lr.ph.i, label %minmax_vec.exit

for.body.i.154:                                   ; preds = %for.body.i.154, %for.body.lr.ph.i
  %indvars.iv173.i = phi i64 [ 0, %for.body.lr.ph.i ], [ %indvars.iv.next174.i, %for.body.i.154 ]
  %sse_idx_min.0160.i = phi <2 x i64> [ zeroinitializer, %for.body.lr.ph.i ], [ %30, %for.body.i.154 ]
  %sse_idx_max.0159.i = phi <2 x i64> [ zeroinitializer, %for.body.lr.ph.i ], [ %33, %for.body.i.154 ]
  %sse_min.0158.i = phi <4 x float> [ <float 0x47EFFFFFE0000000, float 0x47EFFFFFE0000000, float 0x47EFFFFFE0000000, float 0x47EFFFFFE0000000>, %for.body.lr.ph.i ], [ %25, %for.body.i.154 ]
  %sse_max.0157.i = phi <4 x float> [ <float 0x3810000000000000, float 0x3810000000000000, float 0x3810000000000000, float 0x3810000000000000>, %for.body.lr.ph.i ], [ %26, %for.body.i.154 ]
  %sse_idx.0156.i = phi <2 x i64> [ <i64 4294967296, i64 12884901890>, %for.body.lr.ph.i ], [ %35, %for.body.i.154 ]
  %arrayidx.i.153 = getelementptr inbounds float, float* %21, i64 %indvars.iv173.i
  %23 = bitcast float* %arrayidx.i.153 to <4 x float>*
  %24 = load <4 x float>, <4 x float>* %23, align 16, !tbaa !11
  %cmpps.i.138.i = call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %24, <4 x float> %sse_min.0158.i, i8 1) #1
  %cmpps.i.i = call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %sse_max.0157.i, <4 x float> %24, i8 1) #1
  %25 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %sse_min.0158.i, <4 x float> %24, <4 x float> %cmpps.i.138.i) #1
  %26 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %sse_max.0157.i, <4 x float> %24, <4 x float> %cmpps.i.i) #1
  %27 = bitcast <2 x i64> %sse_idx_min.0160.i to <4 x float>
  %28 = bitcast <2 x i64> %sse_idx.0156.i to <4 x float>
  %29 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %27, <4 x float> %28, <4 x float> %cmpps.i.138.i) #1
  %30 = bitcast <4 x float> %29 to <2 x i64>
  %31 = bitcast <2 x i64> %sse_idx_max.0159.i to <4 x float>
  %32 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %31, <4 x float> %28, <4 x float> %cmpps.i.i) #1
  %33 = bitcast <4 x float> %32 to <2 x i64>
  %34 = bitcast <2 x i64> %sse_idx.0156.i to <4 x i32>
  %add.i.i = add <4 x i32> %34, <i32 4, i32 4, i32 4, i32 4>
  %35 = bitcast <4 x i32> %add.i.i to <2 x i64>
  %indvars.iv.next174.i = add nuw nsw i64 %indvars.iv173.i, 4
  %cmp.i = icmp ult i64 %indvars.iv.next174.i, %22
  br i1 %cmp.i, label %for.body.i.154, label %for.cond.for.cond.cleanup_crit_edge.i

for.body.60.lr.ph.i:                              ; preds = %for.cond.cleanup.i
  %36 = zext i32 %and.i to i64
  %37 = trunc i64 %call.i to i32
  %38 = and i32 %37, -4
  %39 = add i32 %37, -1
  %xtraiter246 = and i32 %37, 1
  %lcmp.mod247 = icmp eq i32 %xtraiter246, 0
  br i1 %lcmp.mod247, label %for.body.60.lr.ph.i.split, label %for.body.60.i.prol

for.body.60.i.prol:                               ; preds = %for.body.60.lr.ph.i
  %arrayidx64.i.prol = getelementptr inbounds float, float* %21, i64 %36
  %40 = load float, float* %arrayidx64.i.prol, align 4, !tbaa !7
  %cmp65.i.prol = fcmp olt float %40, %min.1.2.i
  %idx_min.3.i.prol = select i1 %cmp65.i.prol, i32 %and.i, i32 %idx_min.1.2.i
  %min.3.i.prol = select i1 %cmp65.i.prol, float %40, float %min.1.2.i
  %cmp69.i.prol = fcmp ogt float %40, %max.1.2.i
  %max.3.i.prol = select i1 %cmp69.i.prol, float %40, float %max.1.2.i
  %idx_max.3.i.prol = select i1 %cmp69.i.prol, i32 %and.i, i32 %idx_max.1.2.i
  %indvars.iv.next.i.156.prol = or i64 %36, 1
  br label %for.body.60.lr.ph.i.split

for.body.60.lr.ph.i.split:                        ; preds = %for.body.60.lr.ph.i, %for.body.60.i.prol
  %idx_max.3.i.lcssa.unr = phi i32 [ 0, %for.body.60.lr.ph.i ], [ %idx_max.3.i.prol, %for.body.60.i.prol ]
  %max.3.i.lcssa.unr = phi float [ 0.000000e+00, %for.body.60.lr.ph.i ], [ %max.3.i.prol, %for.body.60.i.prol ]
  %min.3.i.lcssa.unr = phi float [ 0.000000e+00, %for.body.60.lr.ph.i ], [ %min.3.i.prol, %for.body.60.i.prol ]
  %idx_min.3.i.lcssa.unr = phi i32 [ 0, %for.body.60.lr.ph.i ], [ %idx_min.3.i.prol, %for.body.60.i.prol ]
  %indvars.iv.i.155.unr = phi i64 [ %36, %for.body.60.lr.ph.i ], [ %indvars.iv.next.i.156.prol, %for.body.60.i.prol ]
  %min.2144.i.unr = phi float [ %min.1.2.i, %for.body.60.lr.ph.i ], [ %min.3.i.prol, %for.body.60.i.prol ]
  %idx_max.2143.i.unr = phi i32 [ %idx_max.1.2.i, %for.body.60.lr.ph.i ], [ %idx_max.3.i.prol, %for.body.60.i.prol ]
  %max.2142.i.unr = phi float [ %max.1.2.i, %for.body.60.lr.ph.i ], [ %max.3.i.prol, %for.body.60.i.prol ]
  %idx_min.2141.i.unr = phi i32 [ %idx_min.1.2.i, %for.body.60.lr.ph.i ], [ %idx_min.3.i.prol, %for.body.60.i.prol ]
  %41 = icmp eq i32 %39, %38
  br i1 %41, label %minmax_vec.exit.loopexit, label %for.body.60.lr.ph.i.split.split

for.body.60.lr.ph.i.split.split:                  ; preds = %for.body.60.lr.ph.i.split
  br label %for.body.60.i

for.body.60.i:                                    ; preds = %for.body.60.i, %for.body.60.lr.ph.i.split.split
  %indvars.iv.i.155 = phi i64 [ %indvars.iv.i.155.unr, %for.body.60.lr.ph.i.split.split ], [ %indvars.iv.next.i.156.1, %for.body.60.i ]
  %min.2144.i = phi float [ %min.2144.i.unr, %for.body.60.lr.ph.i.split.split ], [ %min.3.i.1, %for.body.60.i ]
  %idx_max.2143.i = phi i32 [ %idx_max.2143.i.unr, %for.body.60.lr.ph.i.split.split ], [ %idx_max.3.i.1, %for.body.60.i ]
  %max.2142.i = phi float [ %max.2142.i.unr, %for.body.60.lr.ph.i.split.split ], [ %max.3.i.1, %for.body.60.i ]
  %idx_min.2141.i = phi i32 [ %idx_min.2141.i.unr, %for.body.60.lr.ph.i.split.split ], [ %idx_min.3.i.1, %for.body.60.i ]
  %arrayidx64.i = getelementptr inbounds float, float* %21, i64 %indvars.iv.i.155
  %42 = load float, float* %arrayidx64.i, align 4, !tbaa !7
  %cmp65.i = fcmp olt float %42, %min.2144.i
  %43 = trunc i64 %indvars.iv.i.155 to i32
  %idx_min.3.i = select i1 %cmp65.i, i32 %43, i32 %idx_min.2141.i
  %min.3.i = select i1 %cmp65.i, float %42, float %min.2144.i
  %cmp69.i = fcmp ogt float %42, %max.2142.i
  %max.3.i = select i1 %cmp69.i, float %42, float %max.2142.i
  %idx_max.3.i = select i1 %cmp69.i, i32 %43, i32 %idx_max.2143.i
  %indvars.iv.next.i.156 = add nuw nsw i64 %indvars.iv.i.155, 1
  %arrayidx64.i.1 = getelementptr inbounds float, float* %21, i64 %indvars.iv.next.i.156
  %44 = load float, float* %arrayidx64.i.1, align 4, !tbaa !7
  %cmp65.i.1 = fcmp olt float %44, %min.3.i
  %45 = trunc i64 %indvars.iv.next.i.156 to i32
  %idx_min.3.i.1 = select i1 %cmp65.i.1, i32 %45, i32 %idx_min.3.i
  %min.3.i.1 = select i1 %cmp65.i.1, float %44, float %min.3.i
  %cmp69.i.1 = fcmp ogt float %44, %max.3.i
  %max.3.i.1 = select i1 %cmp69.i.1, float %44, float %max.3.i
  %idx_max.3.i.1 = select i1 %cmp69.i.1, i32 %45, i32 %idx_max.3.i
  %indvars.iv.next.i.156.1 = add nsw i64 %indvars.iv.i.155, 2
  %lftr.wideiv.i.157.1 = trunc i64 %indvars.iv.next.i.156.1 to i32
  %exitcond.i.158.1 = icmp eq i32 %lftr.wideiv.i.157.1, %conv
  br i1 %exitcond.i.158.1, label %minmax_vec.exit.loopexit.unr-lcssa, label %for.body.60.i

minmax_vec.exit.loopexit.unr-lcssa:               ; preds = %for.body.60.i
  %idx_max.3.i.1.lcssa = phi i32 [ %idx_max.3.i.1, %for.body.60.i ]
  %max.3.i.1.lcssa = phi float [ %max.3.i.1, %for.body.60.i ]
  %min.3.i.1.lcssa = phi float [ %min.3.i.1, %for.body.60.i ]
  %idx_min.3.i.1.lcssa = phi i32 [ %idx_min.3.i.1, %for.body.60.i ]
  br label %minmax_vec.exit.loopexit

minmax_vec.exit.loopexit:                         ; preds = %for.body.60.lr.ph.i.split, %minmax_vec.exit.loopexit.unr-lcssa
  %idx_max.3.i.lcssa = phi i32 [ %idx_max.3.i.lcssa.unr, %for.body.60.lr.ph.i.split ], [ %idx_max.3.i.1.lcssa, %minmax_vec.exit.loopexit.unr-lcssa ]
  %max.3.i.lcssa = phi float [ %max.3.i.lcssa.unr, %for.body.60.lr.ph.i.split ], [ %max.3.i.1.lcssa, %minmax_vec.exit.loopexit.unr-lcssa ]
  %min.3.i.lcssa = phi float [ %min.3.i.lcssa.unr, %for.body.60.lr.ph.i.split ], [ %min.3.i.1.lcssa, %minmax_vec.exit.loopexit.unr-lcssa ]
  %idx_min.3.i.lcssa = phi i32 [ %idx_min.3.i.lcssa.unr, %for.body.60.lr.ph.i.split ], [ %idx_min.3.i.1.lcssa, %minmax_vec.exit.loopexit.unr-lcssa ]
  br label %minmax_vec.exit

minmax_vec.exit:                                  ; preds = %minmax_vec.exit.loopexit, %for.cond.cleanup.i
  %min.2.lcssa.i = phi float [ %min.1.2.i, %for.cond.cleanup.i ], [ %min.3.i.lcssa, %minmax_vec.exit.loopexit ]
  %idx_max.2.lcssa.i = phi i32 [ %idx_max.1.2.i, %for.cond.cleanup.i ], [ %idx_max.3.i.lcssa, %minmax_vec.exit.loopexit ]
  %max.2.lcssa.i = phi float [ %max.1.2.i, %for.cond.cleanup.i ], [ %max.3.i.lcssa, %minmax_vec.exit.loopexit ]
  %idx_min.2.lcssa.i = phi i32 [ %idx_min.1.2.i, %for.cond.cleanup.i ], [ %idx_min.3.i.lcssa, %minmax_vec.exit.loopexit ]
  %46 = bitcast %struct.timeval* %curt.i.186 to i8*
  call void @llvm.lifetime.start(i64 16, i8* %46) #1
  %call.i.187 = call i32 @gettimeofday(%struct.timeval* %curt.i.186, %struct.timezone* null) #1
  %tv_sec.i.188 = getelementptr inbounds %struct.timeval, %struct.timeval* %curt.i.186, i64 0, i32 0
  %47 = load i64, i64* %tv_sec.i.188, align 8, !tbaa !1
  %conv.i.189 = sitofp i64 %47 to double
  %tv_usec.i.190 = getelementptr inbounds %struct.timeval, %struct.timeval* %curt.i.186, i64 0, i32 1
  %48 = load i64, i64* %tv_usec.i.190, align 8, !tbaa !6
  %conv1.i.191 = sitofp i64 %48 to double
  %div.i.192 = fdiv double %conv1.i.191, 1.000000e+06
  %add.i.193 = fadd double %conv.i.189, %div.i.192
  call void @llvm.lifetime.end(i64 16, i8* %46) #1
  %sub34 = fsub double %add.i.193, %add.i.147
  %div42 = fdiv double %div, %sub34
  %div44 = fdiv double 0x3EB0000000000000, %sub34
  %49 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !12
  %mul45 = fmul double %sub34, 1.000000e+03
  %call46 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %49, i8* getelementptr inbounds ([107 x i8], [107 x i8]* @.str.3, i64 0, i64 0), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i64 0, i64 0), double %mul45, i64 4, double %div, double %div42, i64 1, double 0x3EB0000000000000, double %div44) #4
  %conv47 = fpext float %min.2.lcssa.i to double
  %call48 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.5, i64 0, i64 0), double %conv47, i32 %idx_min.2.lcssa.i) #1
  %conv49 = fpext float %max.2.lcssa.i to double
  %call50 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.6, i64 0, i64 0), double %conv49, i32 %idx_max.2.lcssa.i) #1
  %50 = bitcast %struct.timeval* %curt.i.178 to i8*
  call void @llvm.lifetime.start(i64 16, i8* %50) #1
  %call.i.179 = call i32 @gettimeofday(%struct.timeval* %curt.i.178, %struct.timezone* null) #1
  %tv_sec.i.180 = getelementptr inbounds %struct.timeval, %struct.timeval* %curt.i.178, i64 0, i32 0
  %51 = load i64, i64* %tv_sec.i.180, align 8, !tbaa !1
  %conv.i.181 = sitofp i64 %51 to double
  %tv_usec.i.182 = getelementptr inbounds %struct.timeval, %struct.timeval* %curt.i.178, i64 0, i32 1
  %52 = load i64, i64* %tv_usec.i.182, align 8, !tbaa !6
  %conv1.i.183 = sitofp i64 %52 to double
  %div.i.184 = fdiv double %conv1.i.183, 1.000000e+06
  %add.i.185 = fadd double %conv.i.181, %div.i.184
  call void @llvm.lifetime.end(i64 16, i8* %50) #1
  %53 = load float*, float** %buf, align 8, !tbaa !12
  br i1 %cmp.154.i, label %for.cond.cleanup.i.164, label %for.body.lr.ph.i.160

for.body.lr.ph.i.160:                             ; preds = %minmax_vec.exit
  %54 = zext i32 %and.i to i64
  br label %for.body.i.169

for.cond.cleanup.i.164.loopexit:                  ; preds = %for.body.i.169
  %.lcssa254 = phi <2 x i64> [ %96, %for.body.i.169 ]
  %.lcssa253 = phi <2 x i64> [ %93, %for.body.i.169 ]
  %.lcssa252 = phi <4 x float> [ %89, %for.body.i.169 ]
  %.lcssa = phi <4 x float> [ %88, %for.body.i.169 ]
  br label %for.cond.cleanup.i.164

for.cond.cleanup.i.164:                           ; preds = %for.cond.cleanup.i.164.loopexit, %minmax_vec.exit
  %sse_idx_min.0.lcssa.i.161 = phi <2 x i64> [ zeroinitializer, %minmax_vec.exit ], [ %.lcssa253, %for.cond.cleanup.i.164.loopexit ]
  %sse_idx_max.0.lcssa.i.162 = phi <2 x i64> [ zeroinitializer, %minmax_vec.exit ], [ %.lcssa254, %for.cond.cleanup.i.164.loopexit ]
  %sse_min.0.lcssa.i = phi <4 x float> [ <float 0x47EFFFFFE0000000, float 0x47EFFFFFE0000000, float 0x47EFFFFFE0000000, float 0x47EFFFFFE0000000>, %minmax_vec.exit ], [ %.lcssa, %for.cond.cleanup.i.164.loopexit ]
  %sse_max.0.lcssa.i = phi <4 x float> [ <float 0x3810000000000000, float 0x3810000000000000, float 0x3810000000000000, float 0x3810000000000000>, %minmax_vec.exit ], [ %.lcssa252, %for.cond.cleanup.i.164.loopexit ]
  %55 = shufflevector <4 x float> %sse_min.0.lcssa.i, <4 x float> undef, <4 x i32> <i32 2, i32 3, i32 0, i32 0>
  %56 = shufflevector <4 x float> %sse_max.0.lcssa.i, <4 x float> undef, <4 x i32> <i32 2, i32 3, i32 0, i32 0>
  %57 = bitcast <2 x i64> %sse_idx_min.0.lcssa.i.161 to <4 x i32>
  %shuffle24.i = shufflevector <4 x i32> %57, <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 0, i32 0>
  %58 = bitcast <2 x i64> %sse_idx_max.0.lcssa.i.162 to <4 x i32>
  %shuffle28.i = shufflevector <4 x i32> %58, <4 x i32> undef, <4 x i32> <i32 2, i32 3, i32 0, i32 0>
  %cmpps.i.172.i = call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %55, <4 x float> %sse_min.0.lcssa.i, i8 1) #1
  %cmpps.i.171.i = call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %sse_max.0.lcssa.i, <4 x float> %56, i8 1) #1
  %59 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %sse_min.0.lcssa.i, <4 x float> %55, <4 x float> %cmpps.i.172.i) #1
  %60 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %sse_max.0.lcssa.i, <4 x float> %56, <4 x float> %cmpps.i.171.i) #1
  %61 = bitcast <2 x i64> %sse_idx_min.0.lcssa.i.161 to <4 x float>
  %62 = bitcast <4 x i32> %shuffle24.i to <4 x float>
  %63 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %61, <4 x float> %62, <4 x float> %cmpps.i.172.i) #1
  %64 = bitcast <2 x i64> %sse_idx_max.0.lcssa.i.162 to <4 x float>
  %65 = bitcast <4 x i32> %shuffle28.i to <4 x float>
  %66 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %64, <4 x float> %65, <4 x float> %cmpps.i.171.i) #1
  %67 = shufflevector <4 x float> %59, <4 x float> undef, <4 x i32> <i32 1, i32 0, i32 0, i32 0>
  %68 = shufflevector <4 x float> %60, <4 x float> undef, <4 x i32> <i32 1, i32 0, i32 0, i32 0>
  %cmpps.i.170.i = call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %67, <4 x float> %59, i8 1) #1
  %cmpps.i.169.i = call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %60, <4 x float> %68, i8 1) #1
  %69 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %59, <4 x float> %67, <4 x float> %cmpps.i.170.i) #1
  %70 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %60, <4 x float> %68, <4 x float> %cmpps.i.169.i) #1
  %71 = shufflevector <4 x float> %63, <4 x float> undef, <4 x i32> <i32 1, i32 0, i32 0, i32 0>
  %72 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %63, <4 x float> %71, <4 x float> %cmpps.i.170.i) #1
  %73 = shufflevector <4 x float> %66, <4 x float> undef, <4 x i32> <i32 1, i32 0, i32 0, i32 0>
  %74 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %66, <4 x float> %73, <4 x float> %cmpps.i.169.i) #1
  %vecext.i.168.i = extractelement <4 x float> %69, i32 0
  %75 = bitcast float %vecext.i.168.i to i32
  %vecext.i.i = extractelement <4 x float> %70, i32 0
  %76 = bitcast float %vecext.i.i to i32
  %77 = bitcast <4 x float> %72 to <4 x i32>
  %vecext.i.163 = extractelement <4 x i32> %77, i32 0
  %78 = bitcast <4 x float> %74 to <4 x i32>
  %vecext66.i = extractelement <4 x i32> %78, i32 0
  br i1 %cmp57.140.i, label %for.body.73.lr.ph.i, label %minmax_vec2.exit

for.body.73.lr.ph.i:                              ; preds = %for.cond.cleanup.i.164
  %79 = zext i32 %and.i to i64
  %80 = trunc i64 %call.i to i32
  %81 = and i32 %80, -4
  %82 = add i32 %80, -1
  %xtraiter = and i32 %80, 1
  %lcmp.mod = icmp eq i32 %xtraiter, 0
  br i1 %lcmp.mod, label %for.body.73.lr.ph.i.split, label %for.body.73.i.prol

for.body.73.i.prol:                               ; preds = %for.body.73.lr.ph.i
  %arrayidx76.i.prol = getelementptr inbounds float, float* %53, i64 %79
  %83 = load float, float* %arrayidx76.i.prol, align 4, !tbaa !7
  %cmp77.i.prol = fcmp olt float %83, %vecext.i.168.i
  %84 = bitcast float %83 to i32
  %min.sroa.0.0.177.i.prol = select i1 %cmp77.i.prol, i32 %84, i32 %75
  %idx_min.1.i.173.prol = select i1 %cmp77.i.prol, i32 %and.i, i32 %vecext.i.163
  %cmp79.i.prol = fcmp ogt float %83, %vecext.i.i
  %max.sroa.0.0.175.i.prol = select i1 %cmp79.i.prol, i32 %84, i32 %76
  %idx_max.1.i.174.prol = select i1 %cmp79.i.prol, i32 %and.i, i32 %vecext66.i
  %indvars.iv.next.i.175.prol = or i64 %79, 1
  br label %for.body.73.lr.ph.i.split

for.body.73.lr.ph.i.split:                        ; preds = %for.body.73.lr.ph.i, %for.body.73.i.prol
  %idx_max.1.i.174.lcssa.unr = phi i32 [ 0, %for.body.73.lr.ph.i ], [ %idx_max.1.i.174.prol, %for.body.73.i.prol ]
  %max.sroa.0.0.175.i.lcssa.unr = phi i32 [ 0, %for.body.73.lr.ph.i ], [ %max.sroa.0.0.175.i.prol, %for.body.73.i.prol ]
  %idx_min.1.i.173.lcssa.unr = phi i32 [ 0, %for.body.73.lr.ph.i ], [ %idx_min.1.i.173.prol, %for.body.73.i.prol ]
  %min.sroa.0.0.177.i.lcssa.unr = phi i32 [ 0, %for.body.73.lr.ph.i ], [ %min.sroa.0.0.177.i.prol, %for.body.73.i.prol ]
  %indvars.iv.i.172.unr = phi i64 [ %79, %for.body.73.lr.ph.i ], [ %indvars.iv.next.i.175.prol, %for.body.73.i.prol ]
  %idx_max.0183.i.unr = phi i32 [ %vecext66.i, %for.body.73.lr.ph.i ], [ %idx_max.1.i.174.prol, %for.body.73.i.prol ]
  %idx_min.0182.i.unr = phi i32 [ %vecext.i.163, %for.body.73.lr.ph.i ], [ %idx_min.1.i.173.prol, %for.body.73.i.prol ]
  %max.sroa.0.0.176181.i.unr = phi i32 [ %76, %for.body.73.lr.ph.i ], [ %max.sroa.0.0.175.i.prol, %for.body.73.i.prol ]
  %min.sroa.0.0.178180.i.unr = phi i32 [ %75, %for.body.73.lr.ph.i ], [ %min.sroa.0.0.177.i.prol, %for.body.73.i.prol ]
  %85 = icmp eq i32 %82, %81
  br i1 %85, label %minmax_vec2.exit.loopexit, label %for.body.73.lr.ph.i.split.split

for.body.73.lr.ph.i.split.split:                  ; preds = %for.body.73.lr.ph.i.split
  br label %for.body.73.i

for.body.i.169:                                   ; preds = %for.body.i.169, %for.body.lr.ph.i.160
  %indvars.iv202.i = phi i64 [ 0, %for.body.lr.ph.i.160 ], [ %indvars.iv.next203.i, %for.body.i.169 ]
  %sse_idx_min.0194.i = phi <2 x i64> [ zeroinitializer, %for.body.lr.ph.i.160 ], [ %93, %for.body.i.169 ]
  %sse_idx_max.0193.i = phi <2 x i64> [ zeroinitializer, %for.body.lr.ph.i.160 ], [ %96, %for.body.i.169 ]
  %sse_min.0192.i = phi <4 x float> [ <float 0x47EFFFFFE0000000, float 0x47EFFFFFE0000000, float 0x47EFFFFFE0000000, float 0x47EFFFFFE0000000>, %for.body.lr.ph.i.160 ], [ %88, %for.body.i.169 ]
  %sse_max.0191.i = phi <4 x float> [ <float 0x3810000000000000, float 0x3810000000000000, float 0x3810000000000000, float 0x3810000000000000>, %for.body.lr.ph.i.160 ], [ %89, %for.body.i.169 ]
  %sse_idx.0190.i = phi <2 x i64> [ <i64 4294967296, i64 12884901890>, %for.body.lr.ph.i.160 ], [ %98, %for.body.i.169 ]
  %arrayidx.i.165 = getelementptr inbounds float, float* %53, i64 %indvars.iv202.i
  %86 = bitcast float* %arrayidx.i.165 to <4 x float>*
  %87 = load <4 x float>, <4 x float>* %86, align 16, !tbaa !11
  %cmpps.i.167.i = call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %87, <4 x float> %sse_min.0192.i, i8 1) #1
  %cmpps.i.i.166 = call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %sse_max.0191.i, <4 x float> %87, i8 1) #1
  %88 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %sse_min.0192.i, <4 x float> %87, <4 x float> %cmpps.i.167.i) #1
  %89 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %sse_max.0191.i, <4 x float> %87, <4 x float> %cmpps.i.i.166) #1
  %90 = bitcast <2 x i64> %sse_idx_min.0194.i to <4 x float>
  %91 = bitcast <2 x i64> %sse_idx.0190.i to <4 x float>
  %92 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %90, <4 x float> %91, <4 x float> %cmpps.i.167.i) #1
  %93 = bitcast <4 x float> %92 to <2 x i64>
  %94 = bitcast <2 x i64> %sse_idx_max.0193.i to <4 x float>
  %95 = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %94, <4 x float> %91, <4 x float> %cmpps.i.i.166) #1
  %96 = bitcast <4 x float> %95 to <2 x i64>
  %97 = bitcast <2 x i64> %sse_idx.0190.i to <4 x i32>
  %add.i.i.167 = add <4 x i32> %97, <i32 4, i32 4, i32 4, i32 4>
  %98 = bitcast <4 x i32> %add.i.i.167 to <2 x i64>
  %indvars.iv.next203.i = add nuw nsw i64 %indvars.iv202.i, 4
  %cmp.i.168 = icmp ult i64 %indvars.iv.next203.i, %54
  br i1 %cmp.i.168, label %for.body.i.169, label %for.cond.cleanup.i.164.loopexit

for.body.73.i:                                    ; preds = %for.body.73.i, %for.body.73.lr.ph.i.split.split
  %indvars.iv.i.172 = phi i64 [ %indvars.iv.i.172.unr, %for.body.73.lr.ph.i.split.split ], [ %indvars.iv.next.i.175.1, %for.body.73.i ]
  %idx_max.0183.i = phi i32 [ %idx_max.0183.i.unr, %for.body.73.lr.ph.i.split.split ], [ %idx_max.1.i.174.1, %for.body.73.i ]
  %idx_min.0182.i = phi i32 [ %idx_min.0182.i.unr, %for.body.73.lr.ph.i.split.split ], [ %idx_min.1.i.173.1, %for.body.73.i ]
  %max.sroa.0.0.176181.i = phi i32 [ %max.sroa.0.0.176181.i.unr, %for.body.73.lr.ph.i.split.split ], [ %max.sroa.0.0.175.i.1, %for.body.73.i ]
  %min.sroa.0.0.178180.i = phi i32 [ %min.sroa.0.0.178180.i.unr, %for.body.73.lr.ph.i.split.split ], [ %min.sroa.0.0.177.i.1, %for.body.73.i ]
  %arrayidx76.i = getelementptr inbounds float, float* %53, i64 %indvars.iv.i.172
  %99 = load float, float* %arrayidx76.i, align 4, !tbaa !7
  %100 = bitcast i32 %min.sroa.0.0.178180.i to float
  %cmp77.i = fcmp olt float %99, %100
  %101 = bitcast float %99 to i32
  %min.sroa.0.0.177.i = select i1 %cmp77.i, i32 %101, i32 %min.sroa.0.0.178180.i
  %102 = trunc i64 %indvars.iv.i.172 to i32
  %idx_min.1.i.173 = select i1 %cmp77.i, i32 %102, i32 %idx_min.0182.i
  %103 = bitcast i32 %max.sroa.0.0.176181.i to float
  %cmp79.i = fcmp ogt float %99, %103
  %max.sroa.0.0.175.i = select i1 %cmp79.i, i32 %101, i32 %max.sroa.0.0.176181.i
  %idx_max.1.i.174 = select i1 %cmp79.i, i32 %102, i32 %idx_max.0183.i
  %indvars.iv.next.i.175 = add nuw nsw i64 %indvars.iv.i.172, 1
  %arrayidx76.i.1 = getelementptr inbounds float, float* %53, i64 %indvars.iv.next.i.175
  %104 = load float, float* %arrayidx76.i.1, align 4, !tbaa !7
  %105 = bitcast i32 %min.sroa.0.0.177.i to float
  %cmp77.i.1 = fcmp olt float %104, %105
  %106 = bitcast float %104 to i32
  %min.sroa.0.0.177.i.1 = select i1 %cmp77.i.1, i32 %106, i32 %min.sroa.0.0.177.i
  %107 = trunc i64 %indvars.iv.next.i.175 to i32
  %idx_min.1.i.173.1 = select i1 %cmp77.i.1, i32 %107, i32 %idx_min.1.i.173
  %108 = bitcast i32 %max.sroa.0.0.175.i to float
  %cmp79.i.1 = fcmp ogt float %104, %108
  %max.sroa.0.0.175.i.1 = select i1 %cmp79.i.1, i32 %106, i32 %max.sroa.0.0.175.i
  %idx_max.1.i.174.1 = select i1 %cmp79.i.1, i32 %107, i32 %idx_max.1.i.174
  %indvars.iv.next.i.175.1 = add nsw i64 %indvars.iv.i.172, 2
  %lftr.wideiv.i.176.1 = trunc i64 %indvars.iv.next.i.175.1 to i32
  %exitcond.i.177.1 = icmp eq i32 %lftr.wideiv.i.176.1, %conv
  br i1 %exitcond.i.177.1, label %minmax_vec2.exit.loopexit.unr-lcssa, label %for.body.73.i

minmax_vec2.exit.loopexit.unr-lcssa:              ; preds = %for.body.73.i
  %idx_max.1.i.174.1.lcssa = phi i32 [ %idx_max.1.i.174.1, %for.body.73.i ]
  %max.sroa.0.0.175.i.1.lcssa = phi i32 [ %max.sroa.0.0.175.i.1, %for.body.73.i ]
  %idx_min.1.i.173.1.lcssa = phi i32 [ %idx_min.1.i.173.1, %for.body.73.i ]
  %min.sroa.0.0.177.i.1.lcssa = phi i32 [ %min.sroa.0.0.177.i.1, %for.body.73.i ]
  br label %minmax_vec2.exit.loopexit

minmax_vec2.exit.loopexit:                        ; preds = %for.body.73.lr.ph.i.split, %minmax_vec2.exit.loopexit.unr-lcssa
  %idx_max.1.i.174.lcssa = phi i32 [ %idx_max.1.i.174.lcssa.unr, %for.body.73.lr.ph.i.split ], [ %idx_max.1.i.174.1.lcssa, %minmax_vec2.exit.loopexit.unr-lcssa ]
  %max.sroa.0.0.175.i.lcssa = phi i32 [ %max.sroa.0.0.175.i.lcssa.unr, %for.body.73.lr.ph.i.split ], [ %max.sroa.0.0.175.i.1.lcssa, %minmax_vec2.exit.loopexit.unr-lcssa ]
  %idx_min.1.i.173.lcssa = phi i32 [ %idx_min.1.i.173.lcssa.unr, %for.body.73.lr.ph.i.split ], [ %idx_min.1.i.173.1.lcssa, %minmax_vec2.exit.loopexit.unr-lcssa ]
  %min.sroa.0.0.177.i.lcssa = phi i32 [ %min.sroa.0.0.177.i.lcssa.unr, %for.body.73.lr.ph.i.split ], [ %min.sroa.0.0.177.i.1.lcssa, %minmax_vec2.exit.loopexit.unr-lcssa ]
  br label %minmax_vec2.exit

minmax_vec2.exit:                                 ; preds = %minmax_vec2.exit.loopexit, %for.cond.cleanup.i.164
  %idx_max.0.lcssa.i.170 = phi i32 [ %vecext66.i, %for.cond.cleanup.i.164 ], [ %idx_max.1.i.174.lcssa, %minmax_vec2.exit.loopexit ]
  %idx_min.0.lcssa.i.171 = phi i32 [ %vecext.i.163, %for.cond.cleanup.i.164 ], [ %idx_min.1.i.173.lcssa, %minmax_vec2.exit.loopexit ]
  %max.sroa.0.0.176.lcssa.i = phi i32 [ %76, %for.cond.cleanup.i.164 ], [ %max.sroa.0.0.175.i.lcssa, %minmax_vec2.exit.loopexit ]
  %min.sroa.0.0.178.lcssa.i = phi i32 [ %75, %for.cond.cleanup.i.164 ], [ %min.sroa.0.0.177.i.lcssa, %minmax_vec2.exit.loopexit ]
  %109 = bitcast %struct.timeval* %curt.i.124 to i8*
  call void @llvm.lifetime.start(i64 16, i8* %109) #1
  %call.i.125 = call i32 @gettimeofday(%struct.timeval* %curt.i.124, %struct.timezone* null) #1
  %tv_sec.i.126 = getelementptr inbounds %struct.timeval, %struct.timeval* %curt.i.124, i64 0, i32 0
  %110 = load i64, i64* %tv_sec.i.126, align 8, !tbaa !1
  %conv.i.127 = sitofp i64 %110 to double
  %tv_usec.i.128 = getelementptr inbounds %struct.timeval, %struct.timeval* %curt.i.124, i64 0, i32 1
  %111 = load i64, i64* %tv_usec.i.128, align 8, !tbaa !6
  %conv1.i.129 = sitofp i64 %111 to double
  %div.i.130 = fdiv double %conv1.i.129, 1.000000e+06
  %add.i.131 = fadd double %conv.i.127, %div.i.130
  call void @llvm.lifetime.end(i64 16, i8* %109) #1
  %sub60 = fsub double %add.i.131, %add.i.185
  %div68 = fdiv double %div, %sub60
  %div70 = fdiv double 0x3EB0000000000000, %sub60
  %112 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !tbaa !12
  %mul71 = fmul double %sub60, 1.000000e+03
  %call72 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %112, i8* getelementptr inbounds ([107 x i8], [107 x i8]* @.str.3, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.8, i64 0, i64 0), double %mul71, i64 4, double %div, double %div68, i64 1, double 0x3EB0000000000000, double %div70) #4
  %113 = bitcast i32 %min.sroa.0.0.178.lcssa.i to float
  %conv73 = fpext float %113 to double
  %call74 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.5, i64 0, i64 0), double %conv73, i32 %idx_min.0.lcssa.i.171) #1
  %114 = bitcast i32 %max.sroa.0.0.176.lcssa.i to float
  %conv75 = fpext float %114 to double
  %call76 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.6, i64 0, i64 0), double %conv75, i32 %idx_max.0.lcssa.i.170) #1
  call void @llvm.lifetime.end(i64 8, i8* %3) #1
  br label %return

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ 0, %for.body.preheader ]
  %call10 = call i32 @rand() #1
  %conv11 = sitofp i32 %call10 to float
  %115 = load float*, float** %buf, align 8, !tbaa !12
  %arrayidx12 = getelementptr inbounds float, float* %115, i64 %indvars.iv
  store float %conv11, float* %arrayidx12, align 4, !tbaa !7
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %lftr.wideiv223 = trunc i64 %indvars.iv.next to i32
  %exitcond224 = icmp eq i32 %lftr.wideiv223, %conv
  br i1 %exitcond224, label %for.cond.cleanup.loopexit, label %for.body

return:                                           ; preds = %minmax_vec2.exit, %if.then
  %retval.0 = phi i32 [ 1, %if.then ], [ 0, %minmax_vec2.exit ]
  ret i32 %retval.0
}

; Function Attrs: nounwind
declare i32 @fprintf(%struct._IO_FILE* nocapture, i8* nocapture readonly, ...) #2

; Function Attrs: nounwind
declare i32 @posix_memalign(i8**, i64, i64) #2

; Function Attrs: nounwind
declare i32 @printf(i8* nocapture readonly, ...) #2

; Function Attrs: nounwind
declare void @srand(i32) #2

; Function Attrs: nounwind
declare i64 @time(i64*) #2

; Function Attrs: nounwind
declare i32 @rand() #2

; Function Attrs: nounwind readnone
declare <4 x float> @llvm.x86.sse.cmp.ps(<4 x float>, <4 x float>, i8) #3

; Function Attrs: nounwind readnone
declare <4 x float> @llvm.x86.sse41.blendvps(<4 x float>, <4 x float>, <4 x float>) #3

; Function Attrs: nounwind
declare i64 @strtol(i8* readonly, i8** nocapture, i32) #2

; Function Attrs: nounwind
declare i32 @puts(i8* nocapture readonly) #1

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+ssse3,+sse3,+sse,+sse2,+sse4.1,+sse4.2,+popcnt" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+ssse3,+sse3,+sse,+sse2,+sse4.1,+sse4.2,+popcnt" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind readnone }
attributes #4 = { cold nounwind }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (http://llvm.org/git/clang.git f860d72ec36b6b7b36e6128297eb143090ca46a3) (http://llvm.org/git/llvm.git c8d166a4373812212ed489c41760bac3b8c043ff)"}
!1 = !{!2, !3, i64 0}
!2 = !{!"timeval", !3, i64 0, !3, i64 8}
!3 = !{!"long", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = !{!2, !3, i64 8}
!7 = !{!8, !8, i64 0}
!8 = !{!"float", !4, i64 0}
!9 = !{!10, !10, i64 0}
!10 = !{!"int", !4, i64 0}
!11 = !{!4, !4, i64 0}
!12 = !{!13, !13, i64 0}
!13 = !{!"any pointer", !4, i64 0}
