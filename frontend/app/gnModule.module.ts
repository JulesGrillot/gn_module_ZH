import { NgModule } from "@angular/core";
import { NgbModule } from "@ng-bootstrap/ng-bootstrap";
import { CommonModule } from "@angular/common";
import { Routes, RouterModule } from "@angular/router";
import { GN2CommonModule } from "@geonature_common/GN2Common.module";
import { MapListService } from "@geonature_common/map-list/map-list.service";
import { NgMultiSelectDropDownModule } from "ng-multiselect-dropdown";
import { AngularMultiSelectModule } from "angular2-multiselect-dropdown";
//Components
import { ZhMapListComponent } from "./zh-map-list/zh-map-list.component";
import { ZhFormMapComponent } from "./zh-forms/map/map.component";
import { ZhFormTab0Component } from "./zh-forms/tabs/tab0/zh-form-tab0.component";
import { ZhFormTab1Component } from "./zh-forms/tabs/tab1/zh-form-tab1.component";
import { ZhFormTab2Component } from "./zh-forms/tabs/tab2/zh-form-tab2.component";
import { ZhFormTab3Component } from "./zh-forms/tabs/tab3/zh-form-tab3.component";
import { ZhFormTab4Component } from "./zh-forms/tabs/tab4/zh-form-tab4.component";
import { ZhFormTab5Component } from "./zh-forms/tabs/tab5/zh-form-tab5.component";
import { ZhFormTab6Component } from "./zh-forms/tabs/tab6/zh-form-tab6.component";
// Service
import { ZhDataService } from "./services/zh-data.service";
import { ZhTabsComponent } from "./zh-forms/tabs/zh-tabs.component";

// my module routing
const routes: Routes = [
  { path: "", component: ZhMapListComponent },
  { path: "forms", component: ZhTabsComponent },
  { path: "forms/:id", component: ZhTabsComponent },
];

@NgModule({
  declarations: [
    ZhMapListComponent,
    ZhTabsComponent,
    ZhFormMapComponent,
    ZhFormTab0Component,
    ZhFormTab1Component,
    ZhFormTab2Component,
    ZhFormTab3Component,
    ZhFormTab4Component,
    ZhFormTab5Component,
    ZhFormTab6Component,
  ],
  imports: [
    CommonModule,
    GN2CommonModule,
    RouterModule.forChild(routes),
    NgbModule.forRoot(),
    AngularMultiSelectModule,
    NgMultiSelectDropDownModule.forRoot(),
    NgbModule,
  ],
  providers: [ZhDataService, MapListService],
  bootstrap: [ZhMapListComponent],
})
export class GeonatureModule {}
