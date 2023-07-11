<?php

namespace App\Http\Controllers;

use App\Models\Konsumen;
use Illuminate\Http\Request;

class KonsumenController extends Controller
{
    public function insert(Request $request)
    {
        $konsumen = Konsumen::create($request->all());
        return response()->json(['massage' => 'succes', 'data' => $konsumen]);
    }
    public function index()
    {
        $konsumen = Konsumen::all();
        return response()->json(['massage' => 'succes', 'data' => $konsumen]);
    }
    public function show($name)
    {
        $konsumen = Konsumen::find($name);
        return response()->json(['massage' => 'succes', 'data' => $konsumen]);
    }
    public function update(Request $request, $id)
    {
        $konsumen = Konsumen::find($id);
        $konsumen->update($request->all());
        return response()->json(['massage' => 'success', 'data' => $konsumen]);
    }

    public function destroy($id)
    {
        $konsumen = Konsumen::find($id);
        $konsumen->delete();
        return response()->json(['massage' => 'succes', 'data' => null]);
    }
    public function banyak(Request $request)
    {
        $konsumen = Konsumen::count();
        return response()->json(['massage' => 'succes', 'data' => $konsumen]);
    }

    public function search($nama)
    {
        //$keyword = $request->input('keyword');

        // Query pencarian data nama member berdasarkan keyword
        // $konsumen = Konsumen::where('nama_konsumen', 'LIKE', "%$keyword%")->get();

        // return response()->json(['nama_konsumen' => $konsumen]);

        return Konsumen::where('nama_konsumen', 'LIKE', '%' . $nama . '%')->get();
    }
}
