--Red-Eyes Maginificent Vine Dragon
function c500317511.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(500317511,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c500317511.spcon)
	e1:SetTarget(c500317511.sptg)
	e1:SetOperation(c500317511.spop)
	c:RegisterEffect(e1)
		--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(500317511,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c500317511.lvcon)
	e2:SetCost(c500317511.cost)
	e2:SetTarget(c500317511.lvtg)
	e2:SetOperation(c500317511.lvop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)

end
function c500317511.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:IsControler(tp) and (ec:IsSetCard(0x785a) or ec:IsSetCard(0x3b)) and  ec:GetSummonType()==SUMMON_TYPE_SPECIAL and (ec:GetPreviousLocation(LOCATION_HAND)or ec:GetPreviousLocation(LOCATION_DECK) or ec:GetPreviousLocation(LOCATION_GRAVE))
end
function c500317511.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c500317511.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
		c:CompleteProcedure()
	end
end
function c500317511.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL and re==e:GetLabelObject()
end
function c500317511.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(500317511,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c500317511.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c500317511.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x785a) and not c:IsSetCard(0x3b)
end
function c500317511.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(500317511,1))
	e:SetLabel(Duel.AnnounceNumber(tp,3,4,5,6,7,8))
end
function c500317511.lvfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x785a) or c:IsSetCard(0x3b) and not c:IsType(TYPE_XYZ)
end
function c500317511.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c500317511.lvfilter2,tp,LOCATION_MZONE,0,e:GetHandler())
	local lc=g:GetFirst()
	local lv=e:GetLabel()
	while lc~=nil do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		lc:RegisterEffect(e1)
		lc=g:GetNext()
				local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(e:GetLabel())
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)

	end
end
function c500317511.con(e,tp,eg,ep,ev,re,r,rp)
		return r==REASON_SUMMON and e:GetHandler():GetReasonCard():IsSetCard(0x785a) or e:GetHandler():GetReasonCard():IsSetCard(0x3b) and bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_ONFIELD)>0
end
function c500317511.ufilter(c,e,tp)
	return c:IsSetCard(0x785a) or c:IsSetCard(0x3b)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c500317511.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c500317511.ufilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c500317511.ufilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c500317511.ufilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c500317511.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsSetCard(0x3b) or tc:IsSetCard(0x785a) and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end