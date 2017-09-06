import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import { Http, Response, Headers, RequestOptions } from '@angular/http';
import 'rxjs/add/operator/map'


@Injectable()
export class SaleService {

  constructor(private http: Http) { }

  buyProduct(user_id, product_id){
  	
  }

}
