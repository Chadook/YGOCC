--created & coded by Lyris
--Wyvern of Stellar Vine
function c101010184.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.FALSE)
	c:RegisterEffect(e3)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(c101010184.spcon)
	e2:SetTarget(c101010184.sptg)
	e2:SetOperation(c101010184.spop)
	c:RegisterEffect(e2)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCondition(c101010184.con)
	e0:SetTarget(c101010184.tg)
	e0:SetOperation(c101010184.op)
	c:RegisterEffect(e0)
end
function c101010184.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c101010184.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND)
end
function c101010184.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,1,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010184.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,1,tp,tp,true,true,POS_FACEUP_ATTACK)>0 then
		c:CompleteProcedure()
	end
end
function c101010184.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c101010184.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x785e)
end
function c101010184.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c101010184.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010184.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101010184,0))
	local g1=Duel.SelectTarget(tp,c101010184.filter,tp,LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,g1:GetCount(),0,0)
end
function c101010184.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoGrave(tg,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if not g then g=tg:Filter(Card.IsLocation,nil,LOCATION_GRAVE) end
	local ct=g:GetCount()
	local dg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_SZONE,nil)
	if ct>0 and dg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=dg:Select(tp,1,ct,nil)
		Duel.HintSelection(rg)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
