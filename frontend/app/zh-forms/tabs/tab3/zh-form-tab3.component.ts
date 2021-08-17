import { Component, EventEmitter, OnInit, Input, Output } from "@angular/core";
import { FormGroup, FormBuilder, Validators } from "@angular/forms";
import { ZhDataService } from "../../../services/zh-data.service";
import { NgbModal } from "@ng-bootstrap/ng-bootstrap";
import { Subscription, Observable } from "rxjs";
import { debounceTime, distinctUntilChanged, map } from "rxjs/operators";
import { ToastrService } from "ngx-toastr";
import { TabsService } from "../../../services/tabs.service";

@Component({
  selector: "zh-form-tab3",
  templateUrl: "./zh-form-tab3.component.html",
  styleUrls: ["./zh-form-tab3.component.scss"],
})
export class ZhFormTab3Component implements OnInit {
  @Input() formMetaData;
  @Output() canChangeTab = new EventEmitter<boolean>();
  form: FormGroup;
  sage: any;
  allSage: any;
  $_currentZhSub: Subscription;
  $_fromChangeSub: Subscription;
  private _currentZh: any;
  corinBioMetaData: any;
  corinTableCol = [
    { name: "CB_code", label: "Code corine Biotope" },
    { name: "CB_label", label: "Libellé corine biotope" },
    { name: "CB_humidity", label: "Humidité" },
  ];
  activityTableCol = [
    { name: "human_activity", label: "Activités humaines" },
    { name: "localisation", label: "Localisation" },
    {
      name: "impacts",
      label: "Impacts (facteurs influençant l'évolution de la zone)",
    },
    { name: "remark_activity", label: "Remarques" },
  ];
  listCorinBio = [];
  posted: boolean = false;
  patchActivity: boolean = false;
  dropdownSettings: any;
  activityForm: FormGroup;
  modalButtonLabel: string;
  modalTitle: string;

  selectedItems = [];
  settings = {};
  listActivity: any = [];
  activitiesInput: any = [];
  submitted: boolean;
  formImpactSubmitted: boolean;
  $_humanActivitySub: Subscription;

  constructor(
    private fb: FormBuilder,
    private _dataService: ZhDataService,
    private _tabService: TabsService,
    public ngbModal: NgbModal,
    private _toastr: ToastrService
  ) {}

  ngOnInit() {
    this.dropdownSettings = {
      singleSelection: false,
      idField: "id_nomenclature",
      textField: "mnemonique",
      searchPlaceholderText: "Rechercher",
      enableCheckAll: false,
      allowSearchFilter: true,
    };

    this.settings = {
      enableCheckAll: false,
      text: "Selectionner",
      labelKey: "mnemonique",
      primaryKey: "id_nomenclature",
      searchPlaceholderText: "Rechercher",
      enableSearchFilter: true,
      groupBy: "category",
    };

    this.getMetaData();
    this.createForm();
    this.initTab();

    this._tabService.getTabChange().subscribe((tabPosition: number) => {
      this.$_fromChangeSub.unsubscribe();
      if (tabPosition == 3) {
        this.initTab();
      }
    });
  }

  initTab() {
    this.$_currentZhSub = this._dataService.currentZh.subscribe((zh: any) => {
      if (zh) {
        this._currentZh = zh;
        this.form.patchValue({
          id_sdage: this._currentZh.properties.id_sdage,
          id_sage: this._currentZh.properties.id_sage,
          id_corine_landcovers: this._currentZh.properties.id_corine_landcovers,
          remark_pres: this._currentZh.properties.remark_pres,
          id_thread: this._currentZh.properties.id_thread,
          global_remark_activity:
            this._currentZh.properties.global_remark_activity,
        });
      }

      this.$_fromChangeSub = this.form.valueChanges.subscribe(() => {
        this.canChangeTab.emit(false);
      });
    });
  }

  getMetaData() {
    this.allSage = [...this.formMetaData["SDAGE-SAGE"]];
    this.corinBioMetaData = [...this.formMetaData["CORINE_BIO"]];
    this.activitiesInput = [...this.formMetaData["ACTIV_HUM"]];
    this.activitiesInput.map((item) => {
      item.disabled = false;
    });
  }

  onFormValueChanges(): void {
    this.form.get("id_sdage").valueChanges.subscribe((val: number) => {
      this.form.get("id_sage").reset();
      this.allSage.forEach((item) => {
        if (val in item) {
          this.sage = Object.values(item)[0];
        }
      });
    });
  }

  createForm(): void {
    this.form = this.fb.group({
      id_sdage: [null, Validators.required],
      id_sage: null,
      corinBio: null,
      id_corine_landcovers: null,
      remark_pres: null,
      id_thread: null,
      global_remark_activity: null,
    });
    this.onFormValueChanges();
  }

  search = (text$: Observable<string>) =>
    text$.pipe(
      debounceTime(200),
      distinctUntilChanged(),
      map((term) =>
        term.length < 1
          ? []
          : this.corinBioMetaData
              .filter(
                (v) =>
                  v.CB_label.toLowerCase().indexOf(term.toLowerCase()) > -1 ||
                  v.CB_code.toLowerCase().indexOf(term.toLowerCase()) > -1
              )
              .slice(0, 10)
      )
    );

  formatter = (result: any) => `${result.CB_code} ${result.CB_label}`;

  onAddCorinBio() {
    if (this.form.value.corinBio) {
      let itemExist = this.listCorinBio.some(
        (item) => item.CB_code == this.form.value.corinBio.CB_code
      );
      if (!itemExist && this.form.value.corinBio.CB_code) {
        this.listCorinBio.push(this.form.value.corinBio);
      }
      this.form.get("corinBio").reset();
      this.canChangeTab.emit(false);
    }
  }

  onDeleteCorin(CB_code: string) {
    this.listCorinBio = this.listCorinBio.filter((item) => {
      return item.CB_code != CB_code;
    });
    this.canChangeTab.emit(false);
  }

  onAddActivity(event, modal) {
    this.patchActivity = false;
    this.modalButtonLabel = "Ajouter";
    this.modalTitle = "Ajout d'une activié humaine";
    this.activityForm = this.fb.group({
      human_activity: [null, Validators.required],
      localisation: [null, Validators.required],
      impacts: [null, Validators.required],
      remark_activity: null,
      frontId: null,
    });
    event.stopPropagation();
    this.ngbModal.open(modal, {
      centered: true,
      size: "lg",
      windowClass: "bib-modal",
    });
  }

  onPostActivity() {
    this.formImpactSubmitted = true;
    if (this.activityForm.valid) {
      let activity = this.activityForm.value;
      let itemExist = this.listActivity.some(
        (item) =>
          item.human_activity.id_nomenclature ==
          activity.human_activity.id_nomenclature
      );
      if (!itemExist) {
        let impactNames = activity.impacts.map((item) => {
          return item["mnemonique"];
        });
        let acrivityToAdd = {
          frontId: Date.now(),
          human_activity: activity.human_activity,
          localisation: activity.localisation,
          remark_activity: activity.remark_activity,
          impacts: null,
        };
        if (activity.impacts && activity.impacts.length > 0) {
          acrivityToAdd.impacts = {
            impacts: activity.impacts,
            mnemonique: impactNames.join("\r\n"),
          };
        }
        this.listActivity.push(acrivityToAdd);
      }
      this.activitiesInput.map((item) => {
        if (item.id_nomenclature == activity.human_activity.id_nomenclature) {
          item.disabled = true;
        }
      });
      this.ngbModal.dismissAll();
      this.activityForm.reset();
      this.selectedItems = [];
      this.canChangeTab.emit(false);
      this.formImpactSubmitted = false;
    }
  }

  onEditActivity(modal: any, activity: any) {
    this.patchActivity = true;
    this.modalButtonLabel = "Modifier";
    this.modalTitle = "Modifier l'activié humaine";
    this.selectedItems = activity.impacts.impacts;
    this.activityForm.patchValue({
      human_activity: activity.human_activity,
      localisation: activity.localisation,
      impacts: activity.impacts.impacts,
      remark_activity: activity.remark_activity,
      frontId: activity.frontId,
    });
    this.$_humanActivitySub = this.activityForm
      .get("human_activity")
      .valueChanges.subscribe(() => {
        this.activitiesInput.map((item) => {
          if (item.id_nomenclature == activity.human_activity.id_nomenclature) {
            item.disabled = false;
          }
        });
      });
    this.ngbModal.open(modal, {
      centered: true,
      size: "lg",
      windowClass: "bib-modal",
    });
  }

  onPatchActivity() {
    this.patchActivity = false;
    this.formImpactSubmitted = true;
    if (this.activityForm.valid) {
      let activity = this.activityForm.value;
      let impactNames = activity.impacts.map((item) => {
        return item["mnemonique"];
      });
      activity.impacts = {
        impacts: activity.impacts,
        mnemonique: impactNames.join("\r\n"),
      };
      this.listActivity = this.listActivity.map((item) =>
        item.frontId != activity.frontId ? item : activity
      );
      this.activitiesInput.map((item) => {
        if (item.id_nomenclature == activity.human_activity.id_nomenclature) {
          item.disabled = true;
        }
      });
      this.ngbModal.dismissAll();
      this.activityForm.reset();
      this.selectedItems = [];
      this.$_humanActivitySub.unsubscribe();
      this.canChangeTab.emit(false);
      this.formImpactSubmitted = false;
    }
  }

  onDeleteActivity(activity: any) {
    this.listActivity = this.listActivity.filter((item) => {
      return item.frontId != activity.frontId;
    });
    this.activitiesInput.map((item) => {
      if (item.id_nomenclature == activity.human_activity.id_nomenclature) {
        item.disabled = false;
      }
    });
    this.canChangeTab.emit(false);
  }

  onDeSelectAll() {
    this.activityForm.get("impacts").setValue([]);
  }

  onFormSubmit() {
    if (this.form.valid) {
      this.submitted = true;

      let formToPost = {
        id_zh: Number(this._currentZh.properties.id_zh),
        id_sdage: this.form.value.id_sdage,
        id_sage: this.form.value.id_sdage,
        id_corine_landcovers: [],
        corine_biotopes: this.listCorinBio,
        remark_pres: this.form.value.remark_pres,
        id_thread: this.form.value.id_thread,
        global_remark_activity: this.form.value.global_remark_activity,
        activities: this.listActivity,
      };
      if (this.form.value.id_corine_landcovers) {
        this.form.value.id_corine_landcovers.forEach((item) => {
          formToPost.id_corine_landcovers.push(item.id_nomenclature);
        });
      }
      this.posted = true;
      this._dataService.postDataForm(formToPost, 3).subscribe(
        () => {
          this.posted = false;
          this.canChangeTab.emit(true);
          this._toastr.success("Vos données sont bien enregistrées", "", {
            positionClass: "toast-top-right",
          });
        },
        (error) => {
          this.posted = false;
          this._toastr.error(error.error, "", {
            positionClass: "toast-top-right",
          });
        }
      );
    }
  }

  ngOnDestroy() {
    this.$_currentZhSub.unsubscribe();
    this.$_fromChangeSub.unsubscribe();
  }
}
