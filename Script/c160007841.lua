--Warda, Sun Rose Fairy of Magnificent Vine
--Keddy was here~
function c160007841.initial_effect(c)
	--Cannot Summon/Set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetCondition(c160007841.sumcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e2)
	--Special Summon Limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_GRAVE)
    e3:SetCode(EFFECT_SPSUMMON_CONDITION)
    e3:SetValue(c160007841.splimit)
    c:RegisterEffect(e3)
    --Cannot be Material
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    c:RegisterEffect(e5)
    local e6=e4:Clone()
    e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e6:SetValue(c160007841.matlimit)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_LVCHANGE)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e7:SetRange(LOCATION_MZONE)
    e7:SetTarget(c160007841.lvtg)
    e7:SetOperation(c160007841.lvop)
    c:RegisterEffect(e7)
end
function c160007841.sfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x785c) 
end
function c160007841.sumcon(e)
return not Duel.IsExistingMatchingCard(c160007841.sfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c160007841.splimit(e,se,sp,st)
    return se:GetHandler():IsSetCard(0x785c)
end
function c160007841.matlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x785c)
end
function c160007841.filter1(c)
    return c:IsFaceup() and c:IsSetCard(0x785c) and c:IsType(TYPE_MONSTER)
end
function c160007841.filter2(c)
    return c:IsFaceup() and c:GetLevel()>0
end
function c160007841.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
 	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c160007841.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c160007841.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c160007841.filter2,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c160007841.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c160007841.lvop(e,tp,eg,ep,ev,re,r,rp)
  	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(c160007841.filter2,tp,LOCATION_MZONE,0,tc)
		local lc=g:GetFirst()
		local lv=tc:GetLevel()
		while lc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			lc:RegisterEffect(e1)
			lc=g:GetNext()
		end
	end
	end