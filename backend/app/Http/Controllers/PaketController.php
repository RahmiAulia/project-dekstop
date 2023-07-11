<?php

namespace App\Http\Controllers;

use App\Models\Paket;
use Illuminate\Http\Request;

class PaketController extends Controller
{
    public function insert(Request $request)
    {
        $paket = Paket::create($request->all());
        return response()->json(['massage' => 'succes', 'data' => $paket]);
    }
    public function index()
    {
        $paket = Paket::all();
        return response()->json(['massage' => 'succes', 'data' => $paket]);
    }
    public function show($name)
    {
        $paket = Paket::find($name);
        return response()->json(['massage' => 'succes', 'data' => $paket]);
    }
    public function update(Request $request, $id)
    {
        $paket = Paket::find($id);
        $paket->update($request->all());
        return response()->json(['massage' => 'success', 'data' => $paket]);
    }

    public function destroy($id)
    {
        $paket = Paket::find($id);
        $paket->delete();
        return response()->json(['massage' => 'succes', 'data' => null]);
    }
}
