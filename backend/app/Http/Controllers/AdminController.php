<?php

namespace App\Http\Controllers;

use App\Models\Admin;
use Illuminate\Http\Request;

class AdminController extends Controller
{
    public function insert(Request $request)
    {
        $admin = Admin::create($request->all());
        return response()->json(['massage' => 'succes', 'data' => $admin]);
    }
    public function index()
    {
        $admin = Admin::all();
        return response()->json(['massage' => 'succes', 'data' => $admin]);
    }
    public function show($name)
    {
        $admin = Admin::find($name);
        return response()->json(['massage' => 'succes', 'data' => $admin]);
    }
    public function update(Request $request, $id)
    {
        $admin = Admin::find($id);
        $admin->update($request->all());
        return response()->json(['massage' => 'success', 'data' => $admin]);
    }

    public function destroy($id)
    {
        $admin = Admin::find($id);
        $admin->delete();
        return response()->json(['massage' => 'succes', 'data' => null]);
    }
    public function search($username)
    {

        $admin = Admin::find($username);
        return Admin::where('username', 'LIKE', '%' . $admin . '%')->get();
    }
}
