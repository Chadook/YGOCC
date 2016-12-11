--created & coded by Lyris
--Bladewing Shinob
function c101010348.initial_effect(c)
--pierce
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	--When you take Battle Damage: You can Special Summon this card from your hand, then if you control a "Blademaster" or "Bladewing" monster, except "Bladewing Shinob", you can apply the following effect. You can only apply this effect of "Bladewing Shinob" once per duel;
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return bit.band(r,REASON_BATTLE)>0 and ep==tp end)
	e1:SetTarget(c101010348.sumtg)
	e1:SetOperation(c101010348.sumop)
	c:RegisterEffect(e1)
end
function c101010348.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010348.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xbb2) and not c:IsCode(101010348)
end
function c101010348.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.GetFlagEffect(tp,101010348)==0
		and Duel.IsExistingMatchingCard(c101010348.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(101010348,0)) then
		Duel.BreakEffect()
		Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
		Duel.RegisterFlagEffect(tp,101010348,0,0,0)
	end
end
