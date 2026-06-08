<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckUserRole
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next,...$roles): Response
    {
     
        $user = $request->user();

        // إذا المستخدم غير مسجل دخول
        if (! $user) {
            return response()->json(['message' => 'غير مصرح'], 401);
        }

        // إذا دور المستخدم غير موجود ضمن الأدوار المسموح بها
        if (! in_array($user->role, $roles)) {
            return response()->json(['message' => 'ليس لديك صلاحية'], 403);
        }

        return $next($request);  
    }
}
