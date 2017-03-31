--Seatector Master
--Keddy was here~
local function ID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end

local id,cod=ID()
function cod.initial_effect(c)
	c:EnableReviveLimit()
    --Special Summmon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(cod.spcon)
    e1:SetOperation(cod.spop)
    c:RegisterEffect(e1)
    --Equip
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,2))
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(cod.eqtg)
    e2:SetOperation(cod.eqop)
    c:RegisterEffect(e2)
   	--Special Summon 2
   	local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_BATTLE_DESTROYED)
    e3:SetCountLimit(1,id)
    e3:SetCondition(cod.spcon2)
    e3:SetCost(cod.spcost)
    e3:SetTarget(cod.sptg2)
    e3:SetOperation(cod.spop2)
    c:RegisterEffect(e3)
end

--Special Summon
function cod.sumfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x33F) and c:IsDestructable()
end
function cod.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cod.sumfilter,tp,LOCATION_ONFIELD,0,3,nil)
end
function cod.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,cod.sumfilter,tp,LOCATION_ONFIELD,0,3,3,nil)
    Duel.Destroy(g,REASON_COST)
end

--Equip
function cod.ecfilter1(c,mc)
	return c:IsSetCard(0x33F) and cod.ecfilter2(c,mc)
end
function cod.ecfilter2(ec,mc)
	local ct1,ct2=mc:GetUnionCount()
	return mc:IsFaceup() and mc:IsSetCard(0x33F) and ec:CheckEquipTarget(mc) and ec:GetCode()~=mc:GetCode() and ct2==0
end
function cod.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x33F) 
		and Duel.IsExistingMatchingCard(cod.ecfilter1,tp,LOCATION_DECK,0,1,nil,c)
end
function cod.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cod.ecfilter1(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingTarget(cod.mfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cod.mfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperaionInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function cod.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local eg=Duel.GetMatchingGroup(cod.ecfilter1,tp,LOCATION_DECK,0,nil,tc)
	if tc and tc:IsRelateToEffect(e) and eg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
		local eqc=eg:FilterSelect(tp,cod.ecfilter1,1,1,nil,tc):GetFirst()
		if not eqc then return end
		if not Duel.Equip(tp,eqc,tc,false) then return end
		eqc:RegisterFlagEffect(eqc:GetCode(),RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
		aux.SetUnionState(eqc)
	end
end

--Special Summon 2
function cod.spcon2(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    local rc=tc:GetReasonCard()
    return eg:GetCount()==1 and rc:IsControler(tp) and rc:IsSetCard(0x33F) 
    	and tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE)
end
function cod.cfilter(c)
    return c:IsSetCard(0x33F) and c:IsDestructable() and c:GetEquipTarget()
end
function cod.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cod.cfilter,tp,LOCATION_SZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,cod.cfilter,tp,LOCATION_SZONE,0,1,1,nil)
    Duel.Destroy(g,REASON_EFFECT)
end
function cod.spfilter(c,e,tp)
	return c:IsSetCard(0x33F) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp)
end
function cod.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cod.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cod.spop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cod.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end